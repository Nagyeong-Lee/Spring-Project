<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-15
  Time: 오후 5:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset='utf-8'/>
    <title>todo_list</title>
    <style>
        * {
            cursor: pointer;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.5/index.global.min.js'></script>
    <script class="cssdesk" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.0/moment.min.js" type="text/javascript"></script>
    <script>
        let i = 0;
        document.addEventListener('DOMContentLoaded', function () {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                locale: 'ko',
                selectable: true,
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                select: function (info) {
                    openPopup();
                },
                eventClick: function (arg) {
                    window.open('/member/showEvent', '', 'width=500, height=500, left=650, top=250');
                    console.log($("event_seq").val());
                },
                events: [
                    $.ajax({
                        url: '/member/registeredEvent',
                        type: 'post',
                        dataType: 'json',
                        success:
                            function (data) {
                                for (let i = 0; i < data.length; i++) {
                                    console.log('----');
                                    console.log(Date.parse(data[i]['startTime']));
                                    calendar.addEvent({
                                        event_seq: data[i]['event_seq'],
                                        title: data[i]['title'],
                                        start: Date.parse(data[i]['startDate']),
                                        end: Date.parse(data[i]['endDate']),
                                        startDate: Date.parse(data[i]['startTime'])
                                    })
                                }
                            }
                    })
                ]
            });//new FullCalendar end
            calendar.render();
        });


        //팝업
        function openPopup() {
            window.open('/member/popup', '', 'width=500, height=500, left=650, top=250');
        }

    </script>
</head>
<body>
<div id='calendar' style="width: 2000px; margin: auto;"></div>
</body>
</html>