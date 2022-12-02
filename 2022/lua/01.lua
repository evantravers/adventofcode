Elves = {};

local elf = 0;
Heaviest = 0;

for line in io.lines("../input/01.txt") do
  if line == "" then
    table.insert(Elves, elf);

    if elf > Heaviest then
      Heaviest = elf;
    end

    elf = 0;
  else
    elf = elf + tonumber(line)
  end
end

table.sort(Elves, function(a, b) return a > b end);

print("p1: " .. Elves[1]);
print("p2: " .. Elves[1] + Elves[2] + Elves[3]);

