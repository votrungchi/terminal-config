vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.timeout = false
vim.o.timeoutlen = 2000
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.list = true
vim.o.confirm = true
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.softtabstop = -1
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.smartindent = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.wrap = false

-- Use system clipboard
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local cur = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[%s/\s\+$//e]]
    pcall(vim.api.nvim_win_set_cursor, 0, cur)
  end,
})

-- Keymaps
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set({ 't', 'i' }, '<M-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<M-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<M-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<M-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<M-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<M-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<M-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<M-l>', '<C-w>l')
vim.keymap.set({ 'n' }, '<M-Up>', ':resize -3<CR>', { silent = true })
vim.keymap.set({ 'n' }, '<M-Down>', ':resize +3<CR>', { silent = true })
vim.keymap.set({ 'n' }, '<M-Left>', ':vertical resize -3<CR>', { silent = true })
vim.keymap.set({ 'n' }, '<M-Right>', ':vertical resize +3<CR>', { silent = true })
vim.keymap.set({ 'n' }, '<leader>c', ':CopilotChat<CR>')
vim.keymap.set({ 'n' }, '<leader>t', ':terminal<CR>')
vim.keymap.set({ 'n' }, '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set({ 'n' }, '<leader>f', ':Pick files<CR>')
vim.keymap.set({ 'n' }, '<leader>b', ':Pick buffers<CR>')
vim.keymap.set({ 'n' }, '<leader>g', ':Pick grep_live<CR>')
vim.keymap.set({ 'n' }, '<leader>h', ':Gitsigns preview_hunk_inline<CR>')
vim.keymap.set({ 'n' }, '<leader>s', ':Gitsigns show_commit<CR>')
vim.keymap.set({ 'n' }, '<leader>r', ':Gitsigns reset_hunk<CR>')
vim.keymap.set({ 'n' }, '<leader>n', ':Gitsigns next_hunk<CR>')
vim.keymap.set({ 'n' }, '<leader>N', ':Gitsigns prev_hunk<CR>')
vim.keymap.set({ 'n' }, '<leader>e', ':Neotree reveal<CR>')

vim.cmd('packadd! nohlsearch')
vim.cmd.colorscheme("habamax")

-- Plugins
vim.pack.add({
  {src = "https://github.com/nvim-lua/plenary.nvim"},
  {src = "https://github.com/MunifTanjim/nui.nvim"},
  {src = "https://github.com/github/copilot.vim"},
  {src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim"},
  {src = "https://github.com/nvim-mini/mini.pick"},
  {src = "https://github.com/lewis6991/gitsigns.nvim"},
  {src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x"},
})

require("mini.pick").setup({
  mappings = {
    move_down = '<C-j>',
    move_up = '<C-k>',
  }
})

require("CopilotChat").setup({
    headers = {
      user = '👷 Chi Vo',
      assistant = '🤡 Copilot',
      tool = '🔧 Tool',
    },
    model = 'gpt-4.1',
    temperature = 0.1,
    window = {
      layout = 'vertical',
      width = 0.5,
    },
    separator = '━━',
    auto_fold = false,
    auto_insert_mode = true,
})

require("gitsigns").setup({
  current_line_blame = true,
})

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})

