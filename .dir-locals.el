((c++-mode
  . ((eval
      . (progn
          (setq lsp-disabled-clients '(c++-mode clangd))
          (require 'dap-gdb)
          (dap-register-debug-provider "gdb" 'dap-gdb--populate-gdb)
          (setq dap-gdb-debug-program `("gdb" "-ex" ,(s-concat "set substitute-path /build/source/ " (projectile-project-root)) "-i" "dap"))
          ;; (setq dap-gdb-debug-program '("rust-gdb" "-i" "dap"))
          (dap-register-debug-template
           "GDB::Run"
           (list
            :type "gdb"
            :request "launch"
            :path "telegram-desktop"
            :name "GDB::Run"
            :program (s-concat (projectile-project-root) "telegram-desktop")
            :cwd (projectile-project-root)
            ;; :cwd (s-concat (projectile-project-root) "Telegram/SourceFiles/")
            :target nil
            ))
          ;; (dap-register-debug-template
          ;;  "GDBServer::Connect"
          ;;  (list :type "gdbserver"
          ;;        :name "GDBServer::Connect"
          ;;        :target nil
          ;;        :cwd nil
          ;;        :executable nil
          ;;        :autorun nil
          ;;        :debugger_args nil
          ;;        :env nil
          ;;        :showDevDebugOutput :json-false
          ;;        :printCalls :json-false))
          )))))
