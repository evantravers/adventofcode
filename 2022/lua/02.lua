Score = 0

function choice(token)
  if token == "X" then return 1 end
  if token == "Y" then return 2 end;
  if token == "Z" then return 3 end;
end

function convert(token)
  if token == "X" then return "A" end
  if token == "Y" then return "B" end;
  if token == "Z" then return "C" end;
end

function win(t1, t2)
  -- draw
  if t1 == convert(t2) then return 3 end;
  -- win
  if t1 == "A" and t2 == "Y" then return 6 end;
  if t1 == "B" and t2 == "Z" then return 6 end;
  if t1 == "C" and t2 == "X" then return 6 end;
  -- lose
  return 0;
end

function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t;
end

for line in io.lines("../input/02.txt") do
  local tokens = split(line)
  Score = Score + choice(tokens[2]) + win(tokens[1], tokens[2])
end

print ('p1: ' .. Score)
