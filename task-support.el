(defun task-add (new-task)
  (interactive "MTask to add: ")
  (call-process "task" nil t nil "add" new-task)
)
