options(menu.graphics = FALSE)

library(colorout)
setOutputColors256(normal = 250, negnum = 237, zero = 237,
                   number = 214, date = 110, string = 143,
                   const = 172, false = 96, true = 96,
                   infinite = 39, stderror = 173,
                   warn = 173, error = 173,
                   verbose = FALSE, zero.limit = NA)

if (interactive()) {
  library(colorout)

  # Use text based web browser to navigate through R docs after help.start()
  if (Sys.getenv("NVIMR_TMPDIR") != "")
    options(browser = function(u) .C("nvimcom_msg_to_nvim",
                                     paste0('StartTxtBrowser("w3m",
                                            "', u, '")')))
  # Load the colorout library
  library(colorout)
  if (Sys.getenv("TERM") != "linux" && Sys.getenv("TERM") != "") {
    setOutputColors256(normal = 250, negnum = 237, zero = 237,
                       number = 214, date = 110, string = 143,
                       const = 172, false = 96, true = 96,
                       infinite = 39, stderror = 173,
                       warn = 173, error = 173,
                       verbose = FALSE, zero.limit = NA)
  }
}
