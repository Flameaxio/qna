$(document).on('turbolinks:load', function () {
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
        $('.edit-title').height(title.height()+20);
        $('.edit-body').height(body.height()+100);
        if ($(this).hasClass('cancel')) {
            $(this).html('Edit');
            $(this).removeClass('cancel');
        } else {
            $(this).html('Cancel');
            $(this).addClass('cancel');
        }
    })
})