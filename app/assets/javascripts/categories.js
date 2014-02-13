$(document).ready(function(){
   $(this).on("ajax:success", "a.delCategory", function(evt, data, status, xhr){ 
     if(data.msg === 'ok'){
       $(this).parents("tr").remove();
     } else {
       alert("不能删除，请检查！");
     }
     return false;
   });
});
