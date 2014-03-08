(require 'term)
(defvar taskwarrior-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map special-mode-map)
    (define-key map "g" 'taskwarrior)
    (define-key map "a" 'task-add)
    map)
  "Keymap for `taskwarrior-mode'.")

(define-derived-mode taskwarrior-mode term-mode "Taskwarrior"
  "Mode for interacting with Taskwarrior")

(defvar taskwarrior-buffer-name "*Taskwarrior*"
  "Name of buffer where output of Taskwarrior is put.")

(defun taskwarrior-sentinel (proc msg)
  "Sentinel for taskwarrior buffers."
  (let ((buffer (process-buffer proc)))
    (when (memq (process-status proc) '(signal exit))
      (if (null (buffer-name buffer))
	  ;; buffer killed
	  (set-process-buffer proc nil)
	(delete-process proc)))))

(defun taskwarrior ()
  (interactive)
  (set-buffer (get-buffer-create taskwarrior-buffer-name))
  (erase-buffer)
  (taskwarrior-mode)

  ; Based on code from term.el in emacs
  (let ((proc (get-buffer-process (current-buffer)))) ; Blast any old process.
	(when proc (delete-process proc)))
  ;; Crank up a new process
  (let ((proc (term-exec-1 "Taskwarrior" (current-buffer) "task" (list "unblocked"))))
    (make-local-variable 'term-ptyp)
    (setq term-ptyp t)
    (set-marker (process-mark proc) (point))
    (set-process-filter proc 'term-emulate-terminal)
    (set-process-sentinel proc 'taskwarrior-sentinel)
    (switch-to-buffer (current-buffer))))
