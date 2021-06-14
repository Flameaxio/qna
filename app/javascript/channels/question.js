$(document).on('turbolinks:load', function () {
    let number = 0;
    $('.add-file-form').not(':last').remove();
    $('.edit-answer-link').click(function (e) {
        e.preventDefault();
        let answer_id = $(this).data('answerId');
        $(".answer-form-" + answer_id).toggle();
        $(".body-" + answer_id).toggle();
        if ($(this).hasClass('cancel')) {
            $(this).html('Edit');
            $(this).removeClass('cancel');
        } else {
            $(this).html('Cancel');
            $(this).addClass('cancel');
        }
    })

    $('.edit-question-link').click(function (e) {
        e.preventDefault();
        let title = $('.question-title');
        let body = $('.question-body');
        title.toggle();
        body.toggle();
        $('.edit-question-form').toggle();
        $('.edit-title').height(title.height() + 20);
        $('.edit-body').height(body.height() + 100);
        if ($(this).hasClass('cancel')) {
            $(this).html('Edit');
            $(this).removeClass('cancel');
        } else {
            $(this).html('Cancel');
            $(this).addClass('cancel');
        }
    })

    $('.add-file').click(function (e) {
        e.preventDefault();
        $('.add-file-form').toggle();
    })

    $('.add-file-answer').click(function (e) {
        e.preventDefault();
        $('.add-file-form-answer').toggle();
    })

    $(document).on('change', $('.file'), function () {
        let string = `<div class="add-file-form" style="">
<label for="question_attachments_attributes_` + ++number + `_file">File</label>
<input class="file new-file" type="file" name="question[attachments_attributes][` + number + `][file]" id="question_attachments_attributes_` + number + `_file">
</div>`
        $('.file-submit').before(string)
    });

    $(document).on('change', $('.file-new'), function () {
        let string = `<div class="add-file-form" style="">
<label for="question_attachments_attributes_` + ++number + `_file">File</label>
<input class="file new-file" type="file" name="question[attachments_attributes][` + number + `][file]" id="question_attachments_attributes_` + number + `_file">
</div>`
        $('.file-new').last().after(string)
    });
})