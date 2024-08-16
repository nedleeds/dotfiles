-- functions.lua
local M = {}

-- 테이블 병합 함수 정의
function M.merge_tables(...)
	local tables = { ... }
	local result = {}

	for _, t in ipairs(tables) do
		for k, v in pairs(t) do
			result[k] = v
		end
	end

	return result
end

return M
