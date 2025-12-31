-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- lua/plugins/rose-pine.lua
return {
	'rose-pine/neovim',
	name = 'rose-pine',
	config = function()
		vim.cmd 'colorscheme rose-pine'
	end,
}
