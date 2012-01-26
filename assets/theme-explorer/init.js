$(function(){
	
	var TE = {
		$container : $("#theme_explorer"),
		currentTheme : location.pathname.split("/")[2],
		$toggler : $("#theme_explorer_hide"), 

	// initialize theme explorer
		init : function(){
			TE.$toggler.click(function(e){
		    TE.toggle();
				e.preventDefault();
		    return false;
		  })
			
			TE.loadThemes();
			TE.setActiveTheme();
		},
		
	// populate themes into theme explorer
		loadThemes : function(){
			var themes = ["twitter", "the-minimum", "tom", "mark-reid"];
		  var cache = "";
		  themes.forEach(function(theme){
		    cache += '<li><a href="/themes/'+ theme +'" class="'+ theme +'">'+ theme +'</a></li>';
		  })
		  TE.$container.find("ul.te_themes").html(cache);
		},
		
	// show/hide theme explorer
		toggle : function(){
			TE.$container.animate({
				bottom: parseInt(TE.$container.css('bottom'),10) == 0 ? -TE.$container.outerHeight() : 0
			});
			TE.$toggler.text( (TE.$toggler.text() === "HIDE") ? "SHOW" : "HIDE" );
		},
		
	// Set current active theme
		setActiveTheme : function(){
			if(typeof TE.currentTheme !== "undefined"){
				TE.$container.find(".current_theme").find("span").text(TE.currentTheme);
				TE.$container.find("ul.te_themes").find("a."+ TE.currentTheme).addClass("active");
			}
		}
		
	}

	TE.init();
})