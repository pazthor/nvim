-- Helper function to find DDEV project root directory
local function find_ddev_root()
  -- Start from current buffer's directory or cwd
  local current_file = vim.fn.expand('%:p:h')
  local start_dir = current_file ~= '' and current_file or vim.fn.getcwd()
  
  -- Search upward for .ddev directory
  local function find_upward(path)
    if path == '' or path == '/' then
      return nil
    end
    
    local ddev_config = path .. '/.ddev/config.yaml'
    if vim.fn.filereadable(ddev_config) == 1 then
      return path
    end
    
    -- Go up one directory
    return find_upward(vim.fn.fnamemodify(path, ':h'))
  end
  
  return find_upward(start_dir)
end

-- Helper function to detect DDEV database connection info
local function get_ddev_db_info()
  -- Find the DDEV project root
  local project_root = find_ddev_root()
  if not project_root then
    print("Debug: No DDEV project found. Searched from: " .. (vim.fn.expand('%:p:h') ~= '' and vim.fn.expand('%:p:h') or vim.fn.getcwd()))
    print("Debug: Current working directory: " .. vim.fn.getcwd())
    print("Debug: Current file directory: " .. vim.fn.expand('%:p:h'))
    return nil
  end
  
  print("Debug: Found DDEV project at: " .. project_root)
  
  -- Try to run ddev describe from the project root
  local handle = io.popen("cd '" .. project_root .. "' && ddev describe 2>&1")
  if not handle then
    print("Debug: Failed to execute ddev describe command")
    return nil
  end
  
  local result = handle:read("*a")
  handle:close()
  
  if not result or result == "" then
    print("Debug: Empty result from ddev describe")
    return nil
  end
  
  print("Debug: ddev describe output:")
  print(result)
  
  -- Try multiple parsing patterns for different DDEV output formats
  local host_port, project_name, db_type
  
  -- Parse DDEV output for database port mapping
  -- Looking for pattern like: "db:5432 -> 127.0.0.1:32772"
  host_port = result:match("db:5432%s*->%s*127%.0%.0%.1:(%d+)")
  if not host_port then
    -- Alternative pattern: "db:3306 -> 127.0.0.1:32772"
    host_port = result:match("db:3306%s*->%s*127%.0%.0%.1:(%d+)")
  end
  if not host_port then
    -- More flexible pattern for any db port mapping
    host_port = result:match("db:%d+%s*->%s*127%.0%.0%.1:(%d+)")
  end
  
  if host_port then
    print("Debug: Found database port: " .. host_port)
  else
    print("Debug: Could not find database port mapping in DDEV output")
  end
  
  -- Extract project name
  project_name = result:match("Project:%s+([%w%-_%.]+)") or result:match("Name:%s+([%w%-_%.]+)")
  
  -- Detect database type from DDEV output
  if result:match("postgres:") or result:match("PostgreSQL") then
    db_type = "postgres"
    print("Debug: Detected PostgreSQL database")
  elseif result:match("mysql:") or result:match("MySQL") or result:match("mariadb:") then
    db_type = "mysql"
    print("Debug: Detected MySQL database") 
  else
    -- Default based on port
    if result:match("db:5432") then
      db_type = "postgres"
      print("Debug: Detected PostgreSQL from port 5432")
    elseif result:match("db:3306") then
      db_type = "mysql"
      print("Debug: Detected MySQL from port 3306")
    else
      db_type = "postgres" -- default to postgres for your setup
      print("Debug: Defaulting to PostgreSQL")
    end
  end
  
  if host_port then
    print("Debug: Found DDEV database - Port: " .. host_port .. ", Project: " .. (project_name or "unknown") .. ", Type: " .. db_type)
    return {
      project = project_name or "ddev-project",
      port = host_port,
      host = "127.0.0.1",
      username = "db",
      password = "db",
      database = "db",
      type = db_type
    }
  else
    print("Debug: Could not parse database port from ddev describe output")
  end
  
  return nil
end

-- Function to generate DDEV connections dynamically
local function get_ddev_connections()
  local connections = {}
  local db_info = get_ddev_db_info()
  
  if db_info then
    -- Create connection URL based on detected database type
    local connection_url
    if db_info.type == "postgres" then
      connection_url = string.format("postgres://%s:%s@%s:%s/%s?sslmode=disable", 
        db_info.username, db_info.password, db_info.host, db_info.port, db_info.database)
    else
      -- Default to MySQL
      connection_url = string.format("mysql://%s:%s@%s:%s/%s", 
        db_info.username, db_info.password, db_info.host, db_info.port, db_info.database)
    end
    
    -- Add the detected connection
    table.insert(connections, {
      name = "ddev_" .. db_info.project .. "_" .. db_info.type,
      type = db_info.type,
      url = connection_url,
    })
    
    -- Also add alternative connection type for testing
    if db_info.type == "mysql" then
      local postgres_url = string.format("postgres://%s:%s@%s:%s/%s?sslmode=disable", 
        db_info.username, db_info.password, db_info.host, db_info.port, db_info.database)
      table.insert(connections, {
        name = "ddev_" .. db_info.project .. "_postgres_alt",
        type = "postgres",
        url = postgres_url,
      })
    else
      local mysql_url = string.format("mysql://%s:%s@%s:%s/%s", 
        db_info.username, db_info.password, db_info.host, db_info.port, db_info.database)
      table.insert(connections, {
        name = "ddev_" .. db_info.project .. "_mysql_alt",
        type = "mysql", 
        url = mysql_url,
      })
    end
  end
  
  return connections
end

return {
  -- Interactive database client for Neovim
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install()
    end,
    keys = {
      { "<leader>db", function() 
        -- Ensure we have multiple windows before opening dbee
        if vim.fn.winnr('$') == 1 then
          vim.cmd('vsplit')
        end
        require("dbee").toggle() 
      end, desc = "Toggle Database UI" },
      { "<leader>do", function() 
        -- Ensure we have multiple windows before opening dbee
        if vim.fn.winnr('$') == 1 then
          vim.cmd('vsplit')
        end
        require("dbee").open() 
      end, desc = "Open Database UI" },
      { "<leader>dc", function() require("dbee").close() end, desc = "Close Database UI" },
      { "<leader>de", function() 
        local query = vim.fn.input("Query: ")
        if query and query ~= "" then
          require("dbee").execute(query)
        end
      end, desc = "Execute Database Query" },
      { "<leader>dE", function()
        -- Execute selected text in visual mode
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        local lines = vim.fn.getline(start_pos[2], end_pos[2])
        
        if #lines > 0 then
          -- Handle partial line selections
          if #lines == 1 then
            lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
          else
            lines[1] = string.sub(lines[1], start_pos[3])
            lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
          end
          
          local query = table.concat(lines, "\n")
          require("dbee").execute(query)
        end
      end, desc = "Execute Selected Query", mode = "v" },
      { "<leader>dr", function()
        -- Refresh DDEV connections with proper directory detection
        print("Debug: Starting DDEV connection refresh...")
        local project_root = find_ddev_root()
        
        if not project_root then
          print("No DDEV project found or DDEV not running")
          print("Searched from: " .. (vim.fn.expand('%:p:h') ~= '' and vim.fn.expand('%:p:h') or vim.fn.getcwd()))
          return
        end
        
        print("Found DDEV project at: " .. project_root)
        
        -- Temporarily change to project directory to get connections
        local original_dir = vim.fn.getcwd()
        vim.cmd("cd " .. vim.fn.fnameescape(project_root))
        
        local ddev_connections = get_ddev_connections()
        
        -- Restore original directory
        vim.cmd("cd " .. vim.fn.fnameescape(original_dir))
        
        if #ddev_connections > 0 then
          print("Found " .. #ddev_connections .. " DDEV database connections")
          for _, conn in ipairs(ddev_connections) do
            print("  - " .. conn.name .. " (" .. conn.type .. ")")
          end
        else
          print("No DDEV connections available (DDEV might not be running)")
        end
      end, desc = "Refresh DDEV Connections" },
      { "<leader>dR", function()
        -- Simple DDEV debug test
        print("=== DDEV DEBUG TEST ===")
        local input_dir = vim.fn.input("DDEV project directory: ", vim.fn.getcwd())
        
        if input_dir and input_dir ~= "" then
          print("Testing directory: " .. input_dir)
          
          -- Check for .ddev/config.yaml
          local ddev_config = input_dir .. "/.ddev/config.yaml"
          print("Looking for: " .. ddev_config)
          print("File exists: " .. (vim.fn.filereadable(ddev_config) == 1 and "YES" or "NO"))
          
          if vim.fn.filereadable(ddev_config) == 1 then
            print("Found DDEV config file!")
            
            -- Test ddev describe command directly
            print("Running: cd '" .. input_dir .. "' && ddev describe")
            local handle = io.popen("cd '" .. input_dir .. "' && ddev describe 2>&1")
            if handle then
              local result = handle:read("*a")
              handle:close()
              print("Command output:")
              print("================")
              print(result or "NO OUTPUT")
              print("================")
              
              if result and result ~= "" then
                -- Try to parse for port info
                print("Searching for database port...")
                local patterns = {
                  "Database:%s+db@127%.0%.0%.1:(%d+)",
                  "Host database port:%s+(%d+)",
                  ":%s*(%d+)->3306",
                  ":%s*(%d+)->5432",
                  "localhost:(%d+)",
                  -- New patterns for your DDEV format:
                  "db:5432%s*->%s*127%.0%.0%.1:(%d+)",
                  "db:3306%s*->%s*127%.0%.0%.1:(%d+)",
                  "db:%d+%s*->%s*127%.0%.0%.1:(%d+)"
                }
                
                for i, pattern in ipairs(patterns) do
                  local port = result:match(pattern)
                  if port then
                    print("Pattern " .. i .. " found port: " .. port)
                  else
                    print("Pattern " .. i .. " (" .. pattern .. ") - NO MATCH")
                  end
                end
              end
            else
              print("Failed to execute ddev describe command")
            end
          else
            print("No .ddev/config.yaml found - not a DDEV project")
          end
        else
          print("No directory provided")
        end
      end, desc = "DDEV Debug Test" },
    },
    config = function()
      -- Get initial DDEV connections with proper directory detection
      local initial_connections = {
        -- Static connections for non-DDEV databases
        {
          name = "postgres_local",
          type = "postgres",
          url = "postgres://postgres:password@localhost:5432/postgres?sslmode=disable",
        },
        -- Remote/Live database examples
        -- {
        --   name = "postgres_staging",
        --   type = "postgres", 
        --   url = "postgres://user:password@staging-host:5432/database?sslmode=require",
        -- },
        -- {
        --   name = "postgres_production",
        --   type = "postgres", 
        --   url = "postgres://user:password@prod-host:5432/database?sslmode=require",
        -- },
      }
      
      -- Add DDEV connections if available using proper directory detection
      local project_root = find_ddev_root()
      if project_root then
        print("nvim-dbee: Found DDEV project at " .. project_root)
        -- Temporarily change to project directory to get connections
        local original_dir = vim.fn.getcwd()
        vim.cmd("cd " .. vim.fn.fnameescape(project_root))
        
        local ddev_connections = get_ddev_connections()
        for _, conn in ipairs(ddev_connections) do
          table.insert(initial_connections, conn)
        end
        
        -- Restore original directory
        vim.cmd("cd " .. vim.fn.fnameescape(original_dir))
        
        if #ddev_connections > 0 then
          print("nvim-dbee: Added " .. #ddev_connections .. " DDEV database connections")
        end
      end

      require("dbee").setup({
        -- Default window layout is required
        window_layout = require("dbee.layouts").Default:new(),
        sources = {
          require("dbee.sources").MemorySource:new(initial_connections),
          require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
          require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/connections.json"),
        },
        -- Optional: Configure the UI
        drawer = {
          disable_help = false,
          mappings = {
            -- Key mappings for the drawer
            { key = "o", mode = "n", action = "action_1" },
            { key = "<cr>", mode = "n", action = "action_1" },
            { key = "c", mode = "n", action = "action_2" },
            { key = "d", mode = "n", action = "action_3" },
          },
        },
        editor = {
          mappings = {
            -- Key mappings for the editor
            { key = "BB", mode = "n", action = "run_statement" },
            { key = "BB", mode = "v", action = "run_selection" },
          },
        },
        result = {
          mappings = {
            -- Key mappings for results
            { key = "S", mode = "n", action = "save_csv" },
            { key = "E", mode = "n", action = "save_json" },
          },
        },
      })
    end,
  },
}