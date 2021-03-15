$(document).on('turbolinks:load', function () {

    let number = 0;
    $('.add-file-form').not(':last').remove();
    $(document).on('click','.edit-answer-link', function (e) {
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

    $(document).on('click','.edit-question-link', function (e) {
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

    $(document).on('click','.add-file', function (e) {
        e.preventDefault();
        $('.add-file-form').toggle();
    })

    $(document).on('click', '.add-file-answer', function (e) {
        e.preventDefault();
        $('.add-file-form-answer').toggle();
    })

    $(document).on('change', $('.file'), function () {
        let string = `<div class="add-file-form" style="">
<label for="question_attachments_attributes_` + ++number + `_file">File</label>
<input class="file new-file" type="file" name="question[attachments_attributes][` + number + `][file]" id="question_attachments_attributes_` + number + `_file">
</div>`
        if ($('.file').val() !== '')
            $('.files').append(string)
    });

    $(document).on('change', $('.file-new'), function () {
        let string = `<div class="add-file-form" style="">
<label for="question_attachments_attributes_` + ++number + `_file">File</label>
<input class="file new-file" type="file" name="question[attachments_attributes][` + number + `][file]" id="question_attachments_attributes_` + number + `_file">
</div>`
        if ($('.file').val() !== '')
            $('.file-new').last().after(string)
    });

    $(document).on('click', $('.upvote'), function () {
        if ($('.upvote').hasClass('upvote-active')) {
            $('.upvote').removeClass('upvote-active');
        } else {
            $('.upvote').addClass('upvote-active');
        }
    })


    $(document).on('ajax:success', '.vote-button', function (e) {
        let answer = e.detail[0];
        if(answer.current_user_opinion.opinion ===  1){
            $('.upvote-' + answer.id).addClass('active-upvote')
            $('.downvote-' + answer.id).removeClass('active-downvote')
        }
        else if(answer.current_user_opinion.opinion === -1){
            $('.downvote-' + answer.id).addClass('active-downvote')
            $('.upvote-' + answer.id).removeClass('active-upvote')
        }
        else{
            $('.upvote-' + answer.id).removeClass('active-upvote')
            $('.downvote-' + answer.id).removeClass('active-downvote')
        }
        $('.score-' + answer.id).html(answer.total_score)
    })

    $(document).on('ajax:error', '.vote-button', function (e) {
        alert(e.detail[0].base)
    })

    $(document).on('click', '.add-comment', function (e){
        e.preventDefault();
        $('.add-comment').toggle()
        $('.add-comment-form').toggle()
    });

    $(document).on('click','.add-comment-answer', function (e){
        e.preventDefault();
        id = this.classList[0].match(/\d+/)[0]
        $(".add-comment-form-" + id).toggle()
    });
})