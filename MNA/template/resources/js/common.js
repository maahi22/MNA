//Javascript

function makeCalendar(myURL, myDiv, callback) {
	//removeActive(document.getElementById("Agenda"));
    // alert('making calendar')
	$('#'+myDiv).addClass('active');
	$('#MainDiv').html(' ');
	if ($('#MainDiv').css('margin-left') == '0px') {
		$('#MainDiv').css('margin-left', '15px');
		$('#MainDiv').css('margin-right', '15px');
		$('#MainDiv').css('width', '-=30px');
		$('#MainDiv').css('margin-top', '20px');
		$('#title').css('display','none')
	}
    $('#DatePicker').css('display','block');
    $('#RefreshButton').css('display','block');
    $('#MainDiv').fullCalendar({
                               //theme: true,
                               header: {
                               left: 'prev,next today',
                               center: 'title',
                               right: 'month,agendaWeek', //,agendaDay
                               },
                               weekMode: 'fixed',
                               //height: 250,
                               //contentHeight: 635,
                               defaultView: 'month',
                               allDaySlot: false,
                               firstDay: 1,
                               firstHour: 9,
                               editable: false,
                               events: function (s, e, callback) {
                               var myStartDate = moment($('#MainDiv').fullCalendar('getView').start);
                               var myEndDate = moment($('#MainDiv').fullCalendar('getView').end);
                               
                               
                               myStartDate = myStartDate.subtract('d', 1);
                               myEndDate = myEndDate.add('d', 1)
                               myStartDate = myStartDate.format("YYYY-MM-DD");
                               myEndDate = myEndDate.format("YYYY-MM-DD");
                               var myURL = SITE_URL+'/mnaservices2/webservice/webservice_agenda_ios.php?encode=json&&method=agenda&&startDate=' + myStartDate + '&&endDate=' + myEndDate;
                               $.ajax({
                                      url: myURL,
                                      dataType: 'json',
                                      success: function (data) {
                                      if (data.length > 0) {
                                      var events = [];
                                      $.each(data, function (i, value) {
                                             $.each(data[i].order, function(j, value) {
                                                    events.push({
                                                                title: data[i].order[j].OrderName,
                                                                start: data[i].AgendaDate + " " + data[i].order[j].OrderStartTime,
                                                                end: data[i].AgendaDate + " " + data[i].order[j].OrderEndTime,
                                                                allDay : false,
                                                                id : j
                                                                });
                                                    if (j > 1) return false;
                                                    });
                                             });
                                      callback(events);
                                      }
                                      }
                                      });
                               },
                               eventClick: function(calEvent, jsEvent, view) {
                               //window.location.replace("orderpaper.html#"+calEvent.start);
                               window.location.href="_OP_@@@"+calEvent.start;
                               }
                               
                               });
}

function makeCalendar1(myStartDate,myEndDate){
    
	$('#MainDiv').html(' ');
	if ($('#MainDiv').css('margin-left') == '0px') {
		$('#MainDiv').css('margin-left', '15px');
		$('#MainDiv').css('margin-right', '15px');
		$('#MainDiv').css('width', '-=30px');
		$('#MainDiv').css('margin-top', '20px');
		$('#title').css('display','none')
	}
    $('#DatePicker').css('display','block');
    $('#RefreshButton').css('display','block');
	
    
	$('#MainDiv').fullCalendar({
                               //theme: true,
                               header: {
                               left: 'prev,next today',
                               center: 'title',
                               right: 'month,agendaWeek', //,agendaDay
                               },
                               weekMode: 'fixed',
                               //height: 250,
                               //contentHeight: 635,
                               defaultView: 'month',
                               allDaySlot: false,
                               firstDay: 1,
                               firstHour: 9,
                               editable: false,
                               events: function (s, e, callback) {
                               
                               myStartDate = moment(myStartDate);
                               myEndDate = moment(myEndDate);
                               myStartDate = myStartDate.subtract('d', 1);
                               myEndDate = myEndDate.add('d', 2);
                               
                               myStartDate = myStartDate.format("YYYY-MM-DD");
                               myEndDate = myEndDate.format("YYYY-MM-DD");
                               
                               var myURL = SITE_URL+'mnaservices2/webservice/webservice_agenda_ios.php?encode=json&&method=agenda&&startDate=' + myStartDate + '&&endDate=' + myEndDate;
                               
                               $.ajax({
                                      url: myURL,
                                      dataType: 'json',
                                      success: function (data) {
                                      
                                      if (data.length > 0) {
                                      var events = [];
                                      $.each(data, function (i, value) {
                                             $.each(data[i].order, function(j, value) {
                                                    events.push({
                                                                title: data[i].order[j].OrderName,
                                                                start: data[i].AgendaDate + " " + data[i].order[j].OrderStartTime,
                                                                end: data[i].AgendaDate + " " + data[i].order[j].OrderEndTime,
                                                                allDay : false,
                                                                id : j
                                                                });
                                                    if (j > 1) return false;
                                                    });
                                             });
                                      callback(events);
                                      }
                                      }
                                      });
                               },
                               eventClick: function(calEvent, jsEvent, view) {
                               //window.location.replace("orderpaper.html#"+calEvent.start);
                               window.location.href="_OP_@@@"+calEvent.start;
                               },
                               
                               });
    
    $('#MainDiv').fullCalendar('gotoDate',myStartDate.split('-')[0],myStartDate.split('-')[1] );
}


function loadYear() {
	//$("#calendarPopupDiv").hide();
	var today = new Date();
	var year = today.getFullYear();
    var scrollDivWidth = 0;
	for (var i = 0; i < year - 1967; i++) {
		str = '';
		str+= '<div id="doc' + (year - i) + '" class="YearItem"><div class="YearDate">' + (year - i) + '</div></div>';
		$('#scroll').append(str);
		$('#doc' + (year - i)).click(function () {
                                     var height = $(this).offset().top + $(this).height() - 3;
                                     var left = $(this).position().left + $(this).width()/2 - 15;
                                     $("#arrow").css("position", "absolute");
                                     $("#arrow").css("left", left);
                                     $("#info").attr("year", $(this).text());
                                     });
        scrollDivWidth+=95+23;
	}
    if(scrollDivWidth>0){
        $('#scroll').css("width",scrollDivWidth);
    }
}

function loadRecentDocs(myURL, myName) {
//   alert(myURL);
	if ($('#MainDiv').css('margin-left') == '15px') {
		$('#MainDiv').css('margin-left', '0px');
		$('#MainDiv').css('margin-right', '0px');
		$('#MainDiv').css('width', '+=30px');
		$('#MainDiv').css('margin-top', '0px');
		$('#title').css('display', 'block');
        $('#title').css('font-family', 'Arial, Helvetica, sans-serif');
	}
    
    $('#DatePicker').css('display','none');
    $('#RefreshButton').css('display','none');
    //    <div id="ScrollYear" style="overflow-x: hidden; overflow-y: hidden; display: inline-block; white-space: nowrap;" class="Year">
	$('#title').text(myName);
	$('#MainDiv').html(' ');
	$('#MainDiv').append('<div class="DebateMain"><div id="latestDoc" class="latestDoc"></div><div id="ScrollYear"  class="Year"><div id="scroller"><div id="scroll"><div id="arrow" class="Arrow"></div></div></div></div><div id="month" class="Month">&nbsp;<div class="MonthItem"><div id="01" class="MonthName">JAN</div></div><div class="MonthItem"><div id="02" class="MonthName">FEB</div></div><div class="MonthItem"><div id="03" class="MonthName">MAR</div></div><div class="MonthItem"><div id="04" class="MonthName">APR</div></div><div class="MonthItem"><div id="05" class="MonthName">MAY</div></div><div class="MonthItem"><div id="06" class="MonthName">JUN</div></div><div class="MonthItem"><div id="07" class="MonthName">JUL</div></div><div class="MonthItem"><div id="08" class="MonthName">AUG</div></div><div class="MonthItem"><div id="09" class="MonthName">SEP</div></div><div class="MonthItem"><div id="10" class="MonthName">OCT</div></div><div class="MonthItem"><div id="11" class="MonthName">NOV</div></div><div class="MonthItem"><div id="12" class="MonthName">DEC</div></div></div></div>');
	$.ajax({
           url: myURL,
           type: 'GET',
           data: {},
           processData: true,
           dataType: 'json',
           success: function (data) {
           var i = 0;
           $('#latestDoc').html('');
          
           $.each(data, function (key) {
                  i++;
                  var myDate = moment(data[key].PublishDate);
                  myDate = myDate.format('MMMM Do YYYY');
                  var myPDF = data[key].FileName;
                  var myThumb = myPDF.replace(".pdf", ".png");
                  var title=data[key].Title;
                  var str = '<div id="docItem' + key + '" class="DocItem"><div class="PdfThumb"><img src="resources/images/AlternateImage.png" data-src="' + myThumb +'" /></div><div class="DebDate"><div class="pdftitle">'+title+'</div>' + myDate + '</div></div>'
                  
                  $('#latestDoc').append(str);
                  if (i>7) return false;
                  $('#docItem' + key).click(function () {
                                            //alert("@@@"+ data[key].UploadId + "@@@" + $("#info").attr("pubname") + "@@@" + $(this).children(2).text() + "@@@" + data[key].FileName);
                                            download(data[key].UploadId,$("#info").attr("pubname"),myDate,data[key].FileName,title);
                                            //window.location.href="_PDF_@@@"+ data[key].UploadId + "@@@" + $("#info").attr("pubname") + "@@@" + $(this).children(2).text() + "@@@" + data[key].FileName;
                                            });
                  });
           }
           }).fail(function() {  doClick('nointernet'); $('#latestDoc').append('<div  class="LibNo" style="color:#000000;font-family: arial; font-size: 16px;margin-left:15px;">No documents found in '+myName+'.</div>'); } );
}

function loadPubs(myId, myName) {
	$("#info").attr("pub", myId);
	var startDate = new Date();
	startDate = moment(startDate);
	startDate = startDate.subtract('day', 30);
	var endDate = new Date();
	endDate = moment(endDate);

	loadRecentDocs(SITE_URL+'mnaservices2/webservice/webservice_publication_ios.php?encode=json&&method=uploads&&publisherId=' + myId + '&&startDate=' + startDate.format("YYYY-MM-DD") + '&&endDate=' + endDate.format("YYYY-MM-DD")+ '&&ishomepage=1', myName);
    
	loadYear();
	var today = new Date();
	var myYear = today.getFullYear();
	var height = $('#doc' + myYear).position().top + $('#doc' + myYear).height();
	var left = $('#doc' + myYear).position().left + $('#doc' + myYear).width()/2 -15;
	$("#arrow").css("position", "absolute");
	$("#arrow").css("left", left);
	$('#month').children().children().bind('click', function () {
                                           var link = "NA_Detail.html#@@@" + $("#info").attr("pub") + "@@@" + $("#info").attr("pubName") + "@@@" + $("#info").attr("year") +  "@@@" + $(this).attr("id") + "@@@" + $('#info');
                                           //window.location.href = link;
                                           window.location.href = "_Detail_@@@" + $("#info").attr("pub") + "@@@" + $("#info").attr("pubName") + "@@@" + $("#info").attr("year") +  "@@@" + $(this).attr("id") + "@@@" + $('#info');
                                           });
	setTimeout( function () {
               $("img").unveil().hide().fadeIn(1000).stop(true, true).error(function () {
                                                                            $(this).attr('src', 'resources/images/AlternateImage.png')
                                                                            });
               loaded();
               //setTimeout(function () { loaded()}, 2000);
               }, 1000);
}

function removeActive(myDiv) {
	$('#'+myDiv).parent().children().each( function () {
                                          $(this).removeClass("active");
                                          })
}

function getAgenda(myId) {
    
	removeActive(myId);
	var today = new Date();
	var year = today.getFullYear();
	var month = today.getMonth() + 1;
	month < 10 ? month = '0' + month : month;
	makeCalendar(SITE_URL+'mnaservices2/webservice/webservice_agenda_ios.php?encode=json&&method=agenda&&agendaDate='+ year + '-' + month, myId);
    
    showSelection(myId,0,0,'');
}

function showSelection(senderid,index, pid,pname){
    if(index>0){
        removeActive(senderid);
        $('#'+senderid).addClass("active");
        $("#info").attr("pubName", pname);
        loadPubs(pid, pname);
    }
    window.location.href="_TAGSEL_@@@"+ senderid + "@@@" + index + "@@@" + pid + "@@@" + pname;
}
/*
 function getAgenda(myId) {
 removeActive(myId);
 var today = new Date();
 var year = today.getFullYear();
 var month = today.getMonth() + 1;
 month < 10 ? month = '0' + month : month;
 makeCalendar(SITE_URL+'mnaservices/webservice/webservice_agenda_ios.php?encode=json&&method=agenda&&agendaDate='+ year + '-' + month, myId);
 
 }*/

function loadLibrary() {
	if ($('#MainDiv').css('margin-left') == '15px') {
		$('#MainDiv').css('margin-left', '0px');
		$('#MainDiv').css('margin-right', '0px');
		$('#MainDiv').css('width', '+=30px');
		$('#MainDiv').css('margin-top', '0px');
		$('#title').css('display', 'block');
	}
	$('#title').text('Library');
	$('#MainDiv').html(' ');
    
	var jsonArray=[];
	var jsonFiles = $('#info').attr('json');
	jsonArray = jsonFiles.split("@@@");
    $('#latestDoc').html('');
    if(jsonFiles!=""){
        for (var i = 0; i < jsonArray.length; i++) {
            var myURL = jsonArray[i];
            $.ajax({
                   url: myURL,
                   type: 'GET',
                   data: {},
                   processData: true,
                   dataType: 'json',
                   success: function (data) {
                   var myDate = data[3];
                   var myPDF = data[1];
                   
                   var myThumb = myPDF.replace(".pdf", ".png");
                   
                   var title=data[4];
                   var str = '<div id="docItem' + data[0] + '" class="LibraryItem"><div class="Ribbon"></div><div class="LibText">' + data[2] + '</div><div  id="docItem' + data[0] + 'Minus" class="Minus"></div><div class="LibDate">' + myDate + '</div><div class="LibTitle">' + title + '</div><div id="docItem' + data[0] + 'Thumb" class="LibThumb"><img src="resources/images/AlternateImage.png" data-src="' + myThumb + '"/></div></div>'
                   
                   $('#latestDoc').append(str);
                   $('#docItem'+data[0]+'Thumb').bind('click', function () {
                                                      //alert("@@@"+ data[0] + "@@@" + data[2] + "@@@" + data[1]);
                                                      
                                                      window.location.href="_PDF_@@@"+ data[0] + "@@@" + data[1] + "@@@" + data[2] + "@@@" + data[3];
                                                      });
                   $('#docItem' + data[0] + 'Minus').bind('click', function () {
                                                          
                                                          $(this).parent().hide('slow');
                                                          window.location.href="_PDFREMOVE_@@@"+ data[1];
                                                          // window.location.href="_PDFREMOVE_@@@"+ data[1]+"@@@"+'#docItem' + data[0] + 'Minus';
                                                          });
                   setTimeout( function () {
                              $("img").unveil().hide().fadeIn(1000).stop(true, true).error(function () {
                                                                                           $(this).attr('src', 'resources/images/AlternateImage.png')
                                                                                           });
                              }, 1000);
                   }
                   });
        }
    }else{
        $('#latestDoc').append('<div class="LibNo" style="color:#000000;font-family: arial; font-size: 16px;">No downloaded items found in your Library</div>');
    }
}

function doClick(refId) {
	//window.location.replace(refId);
	window.location.href="@@@"+refId;
}

function download(param1,param2,param3,param4,param5) {
    
    
    //	$('.downloadBox').show();
    //	$('.DownloadName').text(param2)
	/*for (var i = 1; i < 200; i++) {
     updateProgress(i, 200);
     }*/
    window.location.href="_PDF_@@@"+ param1 + "@@@" + param2 + "@@@" + param3 + "@@@" + param4 +"@@@" + param5;
}

function downloadForOrderPage(param1,param2,param3,param4) {
    //	$('.downloadBox').show();
    //	$('.DownloadName').text('Agenda')
	/*for (var i = 1; i < 200; i++) {
     updateProgress(i, 200);
     }*/
    window.location.href="_PDF_@@@"+ param1 + "@@@" + param2 + "@@@" + param3 + "@@@" + param4 ;
}

function downloadDetails(param1,param2,param3,param4,param5){
    //    $('.downloadBox').show();
    //	$('.DownloadName').text(param3)
	/*for (var i = 1; i < 200; i++) {
     updateProgress(i, 200);
     }*/
    window.location.href="_PDF_@@@"+ param1 + "@@@" + param2 + "@@@" + param3 + "@@@" + param4+"@@@" + param5;
}

function updateProgress(now, total) {
	var dataPerc = now/total * 100;
	$('.DownloadPercent').text("Download in progress " + Math.round(dataPerc) + "%");
	if (dataPerc >= 99) hideProgress();
}

function hideProgress() {
    $('#upProgress').css('display','none');
	$('.downloadBox').hide();
    
	
}

function cancelDownload() {
    
    doClick('pause');
    //	var answer = confirm ("Are you sure you want to cancel the download?")
    //	if (answer) {
    //		$('.downloadBox').hide();
    //		doClick('cancel');
    //	}
    //    else{
    //        doClick('resume');
    //    }
}


