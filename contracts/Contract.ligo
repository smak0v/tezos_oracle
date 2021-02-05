type storage is record[
    oracleAddress : address;
    price : nat;
]

type return is list(operation) * storage

type actions is
| GetData of unit
| HandleCallback of nat

function getData(const s : storage) : return is
block {
    var oracle : contract(contract(nat)) := nil;

    case (Tezos.get_entrypoint_opt("%getPrice", s.oracleAddress) : option(contract(contract(nat)))) of
    | None -> failwith("Oracle not found")
    | Some(c) -> oracle := c
    end;

    var param : contract(nat) := nil;

    case (Tezos.get_entrypoint_opt("%handleCallback", Tezos.self_address) : option(contract(nat))) of
    | None -> failwith("Callback function not found")
    | Some(p) -> param := p
    end;

    const response : list(operation) = list [Tezos.transaction(param, 0mutez, oracle)]
} with (response, s)

function handleCallback(const price : nat; const s : storage) : return is
block {
    s.price := price;
} with ((nil : list(operation)), s)

function main(const a : actions; const s : storage) : return is
case a of
| GetData(v) -> getData(s)
| HandleCallback(price) -> handleCallback(price, s)
end
