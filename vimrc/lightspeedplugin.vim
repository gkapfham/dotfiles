" Lightspeed.nvim {{{

lua << EOF
require'lightspeed'.setup {
    ignore_case = true,
    jump_to_unique_chars = false,
    repeat_ft_with_target_char = true,
    jump_to_unique_chars = {safety_timeout = 400},
    special_keys = {
        next_match_group = '<space>',
        prev_match_group = '<tab>',
      },
  -- jump_on_partial_input_safety_timeout = 400,
  -- This can get _really_ slow if the window has a lot of content,
  -- turn it on only if your machine can always cope with it.
  -- highlight_unique_chars = false,
  -- grey_out_search_area = false,
  -- match_only_the_start_of_same_char_seqs = true,
  -- limit_ft_matches = 5,
  --[[ full_inclusive_prefix_key = '<c-x>', ]]
  -- By default, the values of these will be decided at runtime,
  -- based on `jump_to_first_match`.
  -- labels = nil,
  -- cycle_group_fwd_key = '<Tab>',
  -- cycle_group_bwd_key = '<S-Tab>',
}
EOF

" Use the ; key to repeat a specific use of an invocation using,
" for instance, an f or an s. This means that if you have previously
" typed "f c" then you can you a ";" and it will jump to the next
" matching letter c in the file. This also works for "s cr" as well.
let g:lightspeed_last_motion = ''
augroup lightspeed_last_motion
autocmd!
autocmd User LightspeedSxEnter let g:lightspeed_last_motion = 'sx'
autocmd User LightspeedFtEnter let g:lightspeed_last_motion = 'ft'
augroup end
map <expr> ; g:lightspeed_last_motion == 'sx' ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"

" }}}
