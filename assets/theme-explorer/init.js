$(function(){
	
  var $themeExplorer = $("#theme_explorer");
  var themes = ["twitter", "the-minimum", "tom", "mark-reid"];
  var cache = "";
  
  themes.forEach(function(theme){
    cache += '<li><a href="/themes/'+ theme +'" class="'+ theme +'">'+ theme +'</a></li>';
  })
  $themeExplorer.find("ul.te_themes").html(cache);

  $("#theme_explorer_hide").click(function(e){
    $themeExplorer.animate({
			bottom: parseInt($themeExplorer.css('bottom'),10) == 0 ? -$themeExplorer.outerHeight() : 0
		});
		$(this).text( ($(this).text() === "HIDE") ? "SHOW" : "HIDE" );

    e.preventDefault();
    return false;
  })

	// Set current theme ;
	var currentTheme = location.pathname.split("/")[2];
	
	if(typeof currentTheme !== "undefined"){
		$themeExplorer.find(".current_theme").find("span").text(currentTheme);
		$themeExplorer.find("ul.te_themes").find("a."+ currentTheme).addClass("active");
	}
	
	
})