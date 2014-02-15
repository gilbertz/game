$(document).ready(function(){
   $(this).on("ajax:success", "a#load_materials", function(xhr, setting){ 
     $(this).find("div").text("努力加载中 ...");
     return false;
   });
   $(this).on("ajax:success", "a#load_materials", function(evt, data, status, xhr){ 
     $(this).find("div").text("点击加载更多游戏");
     var content =  "";
     $.each(data.content, function(index, value){
         content += "<div class='grid_4 alpha1'>";
         content += "<div class='home blog paged paged-2 cat-links asides' style='height:48px;overflow:hidden;'>";
         //content += "<a href='#' title='asides'>";
         content += value.name;// + "</a>";
         content += "</div>";
         content += "<div id='post-11945' class='post-11945 post type-post status-publish format-standard hentry category-asides posthome author-admin1310 asides'>"
         content += "<div class=''>";
         content += "<a href=\"/materials/" + value.id + "\">";
         content += "<img alt='Cover' src=";
         content += value.wx_tlimg;
         content += " style=\"width:100%;margin-bottom:0px;\">";
         content += "</a>";   
         content += "</div>";
         content += "</div>";
         content += "</div>";
     });
     $('div.grid_4').last().after($(content));
     if($(content).length < 12) {
       $(this).hide();
     } else {
       $(this).attr("href", data.href);
     }
     return false;
   });
});
