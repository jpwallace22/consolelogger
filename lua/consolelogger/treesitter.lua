-- This was kind of a paint to write and I am sure there are going to be
-- plenty of bugs and issues when jumping between tsx and/or different
-- languaaged. I wrote in some basic debug functions for that reason. Making
-- config have `debug = true` will enable debug mode

--- @class TsUtil
-- Main function to adjust insertion point. Tranverses up the tree and decides where to adjust to
--- @field adjust_insertion_point fun(row: integer): integer

--- @type TsUtil
--- @diagnostic disable-next-line
local M = {}
local ts_utils = require("nvim-treesitter.ts_utils")

-- Check if a node is a valid block (valid for containing statements)
local function is_block_node(node_type)
	return node_type == "block" or node_type == "statement_block"
end

-- Check if a node is a valid statement or declaration
local function is_statement_or_declaration(node_type)
	return node_type:match("_statement$")
		or node_type == "lexical_declaration"
		or node_type == "variable_declaration"
		or node_type == "expression_statement"
end

-- Find the first valid line inside a block or function body
local function find_first_valid_line_in_block(node)
	for child in node:iter_children() do
		if is_block_node(child:type()) then
			local start_row, _, _, _ = child:range()
			return start_row + 1 -- Line inside the block
		end
	end
	return nil
end

-- Debug helper: Print node type and range
local function debug_node(node, cursor_row)
	if node then
		local start_row, _, end_row, _ = node:range()
		print("Node Type: ", node:type(), "Start Row: ", start_row, "End Row: ", end_row, "Cursor Row: ", cursor_row)
	end
end

function M.adjust_insertion_point(cursor_row)
	local config = require("consolelogger.config")
	local node = ts_utils.get_node_at_cursor()

	if not node then
		return cursor_row
	end

	while node do
		if config.options.debug then
			debug_node(node, cursor_row)
		end

		local start_row, _, end_row, _ = node:range()
		local node_type = node:type()

		-- Handle function nodes: Insert at the first valid line inside the body
		if node_type:match("function") then
			local block_start = find_first_valid_line_in_block(node)
			if block_start and cursor_row <= block_start then
				return block_start
			end
		end

		-- Handle statements: Stop traversal and insert directly after the current statement
		if is_statement_or_declaration(node_type) then
			if cursor_row >= start_row and cursor_row <= end_row then
				if config.options.debug then
					print("Statement Found: ", node_type, "Inserting After Row: ", end_row + 1)
				end
				return end_row + 1
			end
		end

		-- Stop traversal when encountering certain parent node types
		if node_type == "statement_block" or node_type == "export_statement" then
			break
		end

		-- Move up the tree to find the parent context
		node = node:parent()
	end

	return cursor_row
end

return M
