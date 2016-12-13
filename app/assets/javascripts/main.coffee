window.snack = (options)-> document.querySelector("#global-snackbar").MaterialSnackbar.showSnackbar(options)
window.loading = false


$(document).on "page:load page:fetch ready", ()->
  componentHandler.upgradeDom()
  $(".close-parent").on "click", (ev)->
    $(this).parent().slideUp()

  $("#notification").on "click", (ev)->
    ev.preventDefault() if $("#notifications").hasClass("active")
    $("#notifications").toggleClass("active")
    return false unless $("#notifications").hasClass("active")
  $(".best_in_place").best_in_place()
  $(".mdl-layout").scroll ->
    if !window.loading && $(".mdl-layout").scrollTop() > $(document).height() - 100
      window.loading = true
      url = $(".next_page").attr("href")
      $.getScript url if url

