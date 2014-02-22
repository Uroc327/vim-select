vim-select
==========

Overview
--------
vim-select lets vim act as a checklist. This plugin is especially useful to select single lines in a pipe.
For example you can do the following:

```shell
ls | vim - | xargs rm
```

This command will list all files in a vim where you can uncheck the files you want to keep (using this plugin).
Then the checked files will get deleted.

vim-select can forward either the whole list or the checked items or the unchecked items to stdout.
You also can save your checklist for further editing.

Supported 'Formats'
-------------------

* GFM checklist `* [ ] and * [x]`
* diff like     `-- and ++`

