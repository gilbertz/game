$(document).ready(function(){
   $("a#add_obj, a.edit_obj").colorbox({closeButton: false});
   $(this).on("ajax:success", "a.ajaxDel", function(evt, data, status, xhr){ 
     $(this).prev().remove();
     $(this).remove();
     return false;
   });

   $(this).on("ajax:success", "a.delMaterial", function(evt, data, status, xhr){ 
     $(this).parents("tr").remove();
     return false;
   });

   $(this).on("click", "span.help-block > a", function(){ 
     var self = $(this);
     $.colorbox({
       href:self.attr("href"),
       closeButton: false
     });
     return false;
   });
});
