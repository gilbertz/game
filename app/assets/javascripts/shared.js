$(document).ready(function(){
  $(this).on('ajax:success', '.ajaxd', function(evt, data, status, xhr){
    var tr = $(this).parents('tr');
    tr.addClass("danger").hide('slow');
    return false;
  });
    

  $("a#a_obj, a.e_obj").colorbox({ 
    fixed: true,
    closeButton: false,
    maxHeight: "600px"
      });


  $("a.preview").colorbox({rel: 'preview', 'width': '900px'});  
  $("a#brands_table").colorbox();
  $("a#tags_table").colorbox();
  $("a#inline, a.sku_images").colorbox({inline: true, width:"70%"});

  $(this).on('click', 'input#select_cate', function(){ 
    $.colorbox({ 
      href: '/manage/categories/for_select',
      fixed: true,
      closeButton: false,
      onComplete:function(){
        $('#cboxLoadedContent').on("ajax:success", "div#paginate span", function(evt, data, status, xhr){
          $("div#for_select").replaceWith(data);
          $.colorbox.resize();
          return false;
        });
      }
    });
    return false;
  });
  
  $(this).on('click', 'a.select_cate', function(){
    $("input#select_cate").val($(this).text());
    $.colorbox.close();
    return false;
  });

  $(this).on('ajax:success', '.del-recommend', function(evt, data, status, xhr){
    var tr = $(this).parents('div.recommend');
    tr.css("background", "red").find(".thumbnail").css("background", "#ebcccc");
    tr.hide('slow');
    return false;
  });

  $(this).on('ajax:success', 'a.del-photo', function(evt, data, status, xhr){
    $(this).parents('div.photo').remove();
    if($('#cboxLoadedContent div.photo').length === 0){
      $.colorbox.close();
    } else {
      $.colorbox.resize();
    }
    return false;
  });

  $(this).on('ajax:success', '.add-recommend', function(evt, data, status, xhr){
    if(data.msg === 'OK！~~~成功~~~'){
      $(this).text('已推');
    }
    alert(data.msg);
    return false;
  });
});
