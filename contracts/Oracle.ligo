type storage is nat * address

type return is list(operation) * storage

type update is
| Address of address
| Store of nat

type actions is
| GetPrice of contract(nat)
| Update of update

function update(const value : update; var s : storage) : return is
block {
    if Tezos.sender =/= s.1 then
        failwith("Not allowed")
    else
        skip;

    case value of
    | Address(addr) -> s.1 := addr
    | Store(n) -> s.0 := n
    end;
} with ((nil : list(operation)), s)

function getPrice(const u : contract(nat); const s : storage) : return is
(list[Tezos.transaction(s.0, 0mutez, u)], s)

function main(const a : actions; const s : storage) : return is
case a of
| GetPrice(v) -> getPrice(v, s)
| Update(v) -> update(v, s)
end
