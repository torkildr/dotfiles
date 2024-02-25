func! myspacevim#before() abort
  set modeline
  set backupcopy=yes
endf

func! myspacevim#after() abort
  set conceallevel=0
endf

