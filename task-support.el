(defun task-add (new-task)
  (interactive "MTask to add: ")
  (call-process "task" nil nil nil "add" new-task)
  (taskwarrior))
