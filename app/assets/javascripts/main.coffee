window.snack = (options)-> document.querySelector("#global-snackbar").MaterialSnackbar.showSnackbar(options)

$(document).on "page: load page:fetch ready", ()->
	$(".best_in_place").best_in_place()
	