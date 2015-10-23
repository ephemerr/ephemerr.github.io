-- do the thing
gen = require"gen"

local t = os.time()
gen.genall()
print(os.clock())
