# Set this to 0 as a workaround. Otherwise fast history searching will cause the following error
# when using Powerlevek10k prompt:
# [bat error]: 'WIDGET=zle-line-pre-redraw': No such file or directory (os error 2)
# This does not occur when using the pure style with p10k.
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_TIMEOUT="1"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=green,bold"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold"