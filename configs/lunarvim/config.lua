-- LunarVim Configuration - Multi-language IDE Setup
-- Python, Go, C++, Java, Node.js/Next.js
-- VS Code-like experience

-- ====================================
-- GENERAL SETTINGS
-- ====================================

lvim.log.level = "warn"
lvim.colorscheme = "onedarker"
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.lua", "*.py", "*.go", "*.cpp", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json" }

-- Appearance
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "

-- Editing
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Performance
vim.opt.updatetime = 100
vim.opt.timeoutlen = 300

-- Font (ajuste conforme sua fonte instalada)
-- vim.opt.guifont = "JetBrains Mono:h12"

-- ====================================
-- VS CODE-LIKE KEYBINDINGS
-- ====================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
lvim.leader = " " -- Space como leader

-- Ctrl+/ para comentar
keymap("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", opts)
keymap("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", opts)

-- Ctrl+S para salvar
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("i", "<C-s>", "<Esc>:w<CR>a", opts)

-- Ctrl+Z para undo
keymap("n", "<C-z>", "u", opts)

-- Ctrl+Y para redo
keymap("n", "<C-y>", "<C-r>", opts)

-- Ctrl+X para cortar
keymap("v", "<C-x>", "\"+d", opts)

-- Ctrl+C para copiar
keymap("v", "<C-c>", "\"+y", opts)

-- Ctrl+V para colar
keymap("i", "<C-v>", "<Esc>\"+pa", opts)
keymap("n", "<C-v>", "\"+p", opts)

-- Alt+Up/Down para mover linha
keymap("n", "<A-Up>", ":m-2<CR>", opts)
keymap("n", "<A-Down>", ":m+1<CR>", opts)
keymap("v", "<A-Up>", ":m-2<CR>gv", opts)
keymap("v", "<A-Down>", ":m+1<CR>gv", opts)

-- Ctrl+Shift+K para deletar linha
keymap("n", "<C-S-k>", "dd", opts)

-- Ctrl+L para selecionar linha
keymap("n", "<C-l>", "<Home>v$", opts)

-- Ctrl+A para selecionar tudo
keymap("n", "<C-a>", "ggVG", opts)

-- Ctrl+H para substituir (find and replace)
keymap("n", "<C-h>", ":%s/", opts)

-- Ctrl+F para procurar no arquivo
keymap("n", "<C-f>", "/", opts)

-- Esc para sair do modo search
keymap("n", "<Esc>", ":nohlsearch<CR><Esc>", opts)

-- ====================================
-- LSP KEYBINDINGS
-- ====================================

keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "<C-k><C-i>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<C-k><C-x>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

-- ====================================
-- NAVIGATION KEYBINDINGS
-- ====================================

-- Ctrl+P para procurar arquivo (Telescope)
keymap("n", "<C-p>", ":Telescope find_files<CR>", opts)

-- Ctrl+Shift+F para procurar em arquivos
keymap("n", "<C-S-f>", ":Telescope live_grep<CR>", opts)

-- Ctrl+Shift+E para explorer (NvimTree)
keymap("n", "<C-S-e>", ":NvimTreeFindFileToggle<CR>", opts)

-- Ctrl+B para toggle sidebar
keymap("n", "<C-b>", ":NvimTreeToggle<CR>", opts)

-- Ctrl+` para terminal
keymap("n", "<C-`>", ":ToggleTerm<CR>", opts)

-- Ctrl+Shift+` para novo terminal
keymap("n", "<C-S-`>", ":ToggleTerm 1<CR>", opts)

-- ====================================
-- LANGUAGE SERVERS (LSP) SETUP
-- ====================================

-- Usar Mason para gerenciar LSPs
local function setup_language_servers()
    local servers = {
        -- Python
        {
            name = "pylsp",
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = { enabled = false },
                        mccabe = { enabled = false },
                        flake8 = { enabled = true, maxLineLength = 120 },
                        mypy = { enabled = true, overrides = { "--ignore-missing-imports", true } },
                        rope = { enabled = true },
                    }
                }
            }
        },
        
        -- Go
        {
            name = "gopls",
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        nilness = true,
                    },
                    staticcheck = true,
                    usePlaceholders = true,
                }
            }
        },
        
        -- C/C++
        {
            name = "clangd",
            settings = {}
        },
        
        -- Java
        {
            name = "jdtls",
            settings = {}
        },
        
        -- TypeScript/JavaScript
        {
            name = "tsserver",
            settings = {}
        },
    }
    
    -- Configure each server
    for _, server_config in ipairs(servers) do
        table.insert(lvim.lsp.automatic_configuration.skipped_servers, server_config.name)
    end
end

setup_language_servers()

-- ====================================
-- FORMATTERS & LINTERS
-- ====================================

-- Python Formatter: Black
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.formatting.black)

-- Python Isort (organize imports)
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.formatting.isort)

-- JavaScript/TypeScript: Prettier
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.formatting.prettier.with({
    extra_args = { "--tab-width", "2", "--use-tabs", "false" }
}))

-- Go: gofmt
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.formatting.gofmt)

-- C/C++: clang-format
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.formatting.clang_format)

-- Linters
-- Python: Flake8
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.diagnostics.flake8)

-- JavaScript/TypeScript: ESLint
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.diagnostics.eslint)

-- Shell: ShellCheck
table.insert(lvim.lsp.null_ls.sources, require("null-ls").builtins.diagnostics.shellcheck)

-- ====================================
-- PLUGINS
-- ====================================

lvim.plugins = {
    -- Comments
    { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
    
    -- Copilot (GitHub)
    { "github/copilot.vim" },
    
    -- Colorizer (visualiza cores)
    { "norcalli/nvim-colorizer.lua", config = function() require("colorizer").setup() end },
    
    -- Trouble (diagnósticos)
    { "folke/trouble.nvim", config = function() require("trouble").setup() end },
    
    -- Gitsigns
    { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end },
    
    -- Surround (alterador de delimitadores)
    { "tpope/vim-surround" },
    
    -- Indent blankline
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                char = "│",
                show_end_of_line = false,
            })
        end
    },
}

-- ====================================
-- TREESITTER
-- ====================================

lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "cpp",
    "go",
    "java",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "vim",
    "yaml",
    "html",
    "css",
}

lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.indent.enabled = true

-- ====================================
-- NVIM-TREE (File Explorer)
-- ====================================

lvim.builtin.nvimtree.setup.filters.dotfiles = false
lvim.builtin.nvimtree.setup.filters.custom = { ".git", "node_modules", "__pycache__" }
lvim.builtin.nvimtree.setup.view.width = 35

-- ====================================
-- TELESCOPE (Fuzzy Finder)
-- ====================================

lvim.builtin.telescope.defaults.vimgrep_arguments = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
}

-- ====================================
-- TERMINAL (ToggleTerm)
-- ====================================

lvim.builtin.terminal.active = true
lvim.builtin.terminal.size = 20

-- ====================================
-- CMP (Autocomplete)
-- ====================================

local cmp = require("cmp")
lvim.builtin.cmp.mapping["<C-Space>"] = cmp.mapping.complete()
lvim.builtin.cmp.mapping["<C-j>"] = cmp.mapping.select_next_item()
lvim.builtin.cmp.mapping["<C-k>"] = cmp.mapping.select_prev_item()

-- ====================================
-- DAPS (Debug Adapter Protocol)
-- ====================================

-- Python debugger
local dap = require("dap")
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            return "/usr/bin/python3"
        end,
    },
}

dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
}

-- ====================================
-- AUTOCMDS
-- ====================================

-- Formato automático em save
-- (Já configurado em format_on_save acima)

-- ====================================
-- CUSTOM COMMANDS
-- ====================================

-- Comando para executar arquivo Python
vim.cmd("command! Python !python3 %")

-- Comando para executar arquivo Go
vim.cmd("command! GoRun !go run %")

-- Comando para executar projeto Node.js
vim.cmd("command! NodeRun !npm run dev")

-- ====================================
-- FIM DA CONFIGURAÇÃO
-- ====================================

print("LunarVim configurado com sucesso!")
