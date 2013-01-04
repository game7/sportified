
// button handlers
$(function() {
  $(document).on('click', '.block a.edit', function(){
    toggleEditor($(this));
    return false;
  });
  $(document).on('click', '.section a.move_section_up', function(){
    var $section = $(this).closest('.section');
    $section.insertBefore($section.prev());
    updateSectionPositions();
    return false;
  });
  $(document).on('click', '.section a.move_section_down', function(){
    var $section = $(this).closest('.section');
    $section.insertAfter($section.next());
    updateSectionPositions();
    return false;
  });      
  $(document).on('click', '.block a.move_up', function(){
    var $block = $(this).closest('.block');
    $block.insertBefore($block.prev());
    updateBlockPositions($(this).closest(".blocks"));
    return false;
  });
  $(document).on('click', '.block a.move_down', function(){
    var $block = $(this).closest('.block');
    $block.insertAfter($block.next());
    updateBlockPositions($(this).closest(".blocks"));
    return false;
  });
  $(document).on('click', '.block a.move_left', function(){
    var $block = $(this).closest('.block');
    var $origin = $block.closest('.column');        
    var $target = $origin.prev('.column').find('.blocks');
    $block.appendTo($target);
    updateBlockPositions($origin);
    updateBlockPositions($target);
    return false;
  });      
  $(document).on('click', '.block a.move_right', function(){
    var $block = $(this).closest('.block');
    var $origin = $block.closest('.column');
    var $target = $origin.next('.column').find('.blocks');
    $block.appendTo($target);
    updateBlockPositions($origin);
    updateBlockPositions($target);        
    return false;
  });
  $(document).on('click', '.block a.section_up', function(){
    var $block = $(this).closest('.block');
    var $origin = $block.closest('.column');
    var column = $origin.attr('data-column');
    var $columns = $origin.closest('.section').prev('.section').find('.column');
    var $target = (column >= $columns.size() ? $columns.last().find('.blocks') : $columns.eq(column).find('.blocks'));
    $block.appendTo($target);
    updateBlockPositions($origin);
    updateBlockPositions($target);        
    return false;
  });      
  $(document).on('click', '.block a.section_down', function(){
    var $block = $(this).closest('.block');
    var $origin = $block.closest('.column');
    var column = $origin.attr('data-column');
    var $columns = $origin.closest('.section').next('.section').find('.column');
    var $target = (column >= $columns.size() ? $columns.last().find('.blocks') : $columns.eq(column).find('.blocks'));
    $block.appendTo($target);
    updateBlockPositions($origin);
    updateBlockPositions($target);        
    return false;
  });      
        
  $(document).on('click', '.section a.add_block', function(){
    $('#column').val( $(this).attr('data-column') );
    $('#section_id').val( $(this).attr('data-section_id') );
  });
  $(document).on('click', '#block-catalog button.add_block', function(){
    $('#block_type').val( $(this).attr('data-block_type') );
  });   
  
  $('#toggle-edit').click(function(){
    toggleDisplayMode('edit');
  });
  $('#toggle-organize').click(function(){
    toggleDisplayMode('organize');
  });
  $('#toggle-preview').click(function(){
    toggleDisplayMode('preview');
  });            
  
});

var displayMode = "edit";

function toggleDisplayMode(mode) {
  var isChanged = (displayMode != mode);
  if (isChanged) {
    switch(mode) {
      case "edit":
        $(".section, .block").addClass("editable");
        $(".block .content").show();
        break;
      case "organize":
        $(".section, .block").addClass("editable");
        $(".block .content").hide();
        break;
      case "preview":
        $(".section, .block").removeClass("editable");
        $(".block .content").show();
        break;
    }
    displayMode = mode;
  }
}

function updateSectionPositions(column) {
  var items = '';
  $.each($(".section"), function(){
    var id = $(this).attr("id");
    items += id.replace("_","[]=") + "&";
  })
  $.ajax({
    type: 'post',
    data: items ,
    dataType: 'json',
    url: '#{position_page_sections_path(@page)}'
  });
}  

function updateBlockPositions(column) {
  var items = '';
  items += 'section_id=' + column.closest('.section').attr('id').replace('section_','') + '&';
  items += 'column=' + column.closest('[data-column]').attr('data-column') + '&';
  $.each(column.find(".block"), function(){
    var id = $(this).attr("id");
    items += id.replace("_","[]=") + "&";
  })
  $.ajax({
    type: 'post',
    data: items ,
    dataType: 'json',
    url: '#{position_page_blocks_path(@page)}'
  });
}