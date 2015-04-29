//var $ = function (name) {
	//return document.getElementById(name);
//} replaced by real jquery


var ctrl 			= {};
ctrl.seq 			= [];
ctrl.pos 			= 0;
ctrl.loop 			= false;

ctrl.delay = {
	f : 500,
	B : 700,
	x : 1000
};

ctrl.play = function (val) {
	fsk.generate(val);
	setTimeout(function () {
		fsk.play();
		ctrl.posCmd(val);
	}, 10);
};

ctrl.sendCmd = function (elem) {
	'use strict';
	var val = elem.title;
	console.log('Send command: ' + val);
	ctrl.play(val);
};

ctrl.local = function (key, value) {
    var has = function () {
        try {
            return 'localStorage' in window && window.localStorage !== null;
        } catch (e) {
            return false;
        }
    };
    if (value === undefined) {
        if (has()) {
            var val = window.localStorage[key];
            if (val !== undefined) {
                val = JSON.parse(val);
            }
            return val;
        } else {
            return undefined;
        }
    } else {
        if (has()) {
            window.localStorage[key] = JSON.stringify(value);
            return true;
        } else {
            return false;
        }
    }
};

ctrl.run = {};
ctrl.run.i = 0;
ctrl.run.next = function () {
	if (	ctrl.seq[ctrl.run.i] !== null 
		&& 	ctrl.seq[ctrl.run.i] !== undefined) {
		console.log(ctrl.seq[ctrl.run.i]);
		ctrl.highlight(ctrl.run.i);
		if (ctrl.seq[ctrl.run.i] !== 'x') { 
			ctrl.play(ctrl.seq[ctrl.run.i]); 
		}
		setTimeout(function () {
			ctrl.run.i++;
			ctrl.run.next();
		}, ctrl.delay[ctrl.seq[ctrl.run.i]]);
	} else if (ctrl.run.i < ctrl.seq.length) {
		ctrl.run.i++;
		ctrl.run.next();
	} else {
		console.log('End sequence');
		ctrl.highlight(false);
	}
};
ctrl.run.start = function () {
	console.log('Started running sequence');
	ctrl.run.i = 0;
	ctrl.run.next();
};
ctrl.run.end = function () {
	console.log('Finished running sequence');
	ctrl.highlight(false);
	if (ctrl.loop) {
		ctrl.run.start();
	}
};

ctrl.highlight = function (i) {
	$('.seq > div > div').removeClass('highlight');
	if (i !== undefined && i !== false) {
		//console.log(i);
		$('.seq .row_f > div').eq(i).addClass('highlight');
		$('.seq .row_B > div').eq(i).addClass('highlight');
		$('.seq .row_x > div').eq(i).addClass('highlight');
	}
};

ctrl.setLoop = function () {
	if (ctrl.loop) {
		ctrl.loop = false;
		$('.loop').text('LOOP off');
		$('.loop').removeClass('on').addClass('off');
		ctrl.local('loop', {set: false});
	} else {
		ctrl.loop = true;
		$('.loop').text('LOOP on');
		$('.loop').removeClass('off').addClass('on')
		ctrl.local('loop', {set: true});
	}
};

ctrl.changeDelay = function (saved) {
	var delay;
	if (saved === undefined) {
		delay = prompt('Delay', ctrl.delay.x /1000);
	} else {
		delay = saved / 1000;
	}
	if (delay !== null) {
		delay = parseInt(delay) * 1000;
		ctrl.delay.x = delay;
		$('#delayVal').text(delay / 1000);
		ctrl.local('delay', delay);
	}
};

//counter management
ctrl.posCmd = function (val) {
	if (val === 'f') {
		ctrl.pos++;
	} else if (val === 'b') {
		ctrl.pos--;
	}
	ctrl.local('pos', ctrl.pos);
	$('#monitor').text(ctrl.pos);
};

ctrl.setPos = function (pos) {
	if (pos === undefined) {
		ctrl.pos = parseInt(prompt('Frame position'));
	} else {
		ctrl.pos = parseInt(pos);
	}
	ctrl.local('pos', ctrl.pos);
	$('#monitor').text(ctrl.pos);
};

ctrl.set = function (t) {
	var pos = parseInt(t.innerHTML);

	if (ctrl.hasClass(t, 'set')) {
		ctrl.removeClass(t, 'set');
		ctrl.seq[pos] = null;
	} else {
		var which = t.className;
		var rows = $('#seq')[0].children;
		for (var i = 0; i < rows.length; i++) {
			var cell = rows[i].children[pos];
			if (cell.className.indexOf(which) === -1) {
				ctrl.removeClass(cell, 'set');
			}
		}
		ctrl.addClass(t, 'set');
		ctrl.seq[pos] = t.title;
	}
	ctrl.local('seq', ctrl.seq);
};

ctrl.layout = function () {
	var layout = $('#seq')[0],
		row = layout.children,
		cell = null,
		w = $(window).width(),
		btn = $('.seq > div > div').eq(0).width() + 4,
		num = Math.floor((w - 16) / btn) - 1;
	for (var i = 0; i < row.length; i++) {
		if (ctrl.seq[0] !== undefined && ctrl.seq[0] !== null) {
			if (row[i].children[0].title === ctrl.seq[0]) {
				ctrl.addClass(row[i].children[0], 'set');
			}
		}
		for (var x = 0; x < num; x++) {	
			cell = null;
			cell = row[i].children[0].cloneNode(true);
			cell.innerHTML = parseInt(cell.innerHTML) + x + 1;
			ctrl.removeClass(cell, 'set');
			if (ctrl.seq !== [] && ctrl.seq[x+1] !== undefined && ctrl.seq[x+1] !== null) {
				if (cell.title === ctrl.seq[x+1]) {
					ctrl.addClass(cell, 'set');
				}
			}
			row[i].appendChild(cell);
		}
	}
	if (ctrl.seq === []) {
		for (var y = 0; y < num; y++) { 
			ctrl.seq.push(null);
		}
	}
};

ctrl.onload = function () {
	var delay = ctrl.local('delay');
	console.log(delay);
	if (delay !== undefined && delay !== false) {
		ctrl.changeDelay(delay);
	}
	var pos = ctrl.local('pos');
	console.log(pos);
	if (pos !== undefined && pos !== false) {
		ctrl.setPos(pos);
	}
	var loop = ctrl.local('loop');
	console.log(loop);
	if (loop !== undefined && loop !== false) {
		if (loop.set === true) {
			ctrl.setLoop(); //toggles to true
		}
	}
	var seq = ctrl.local('seq');
	console.log(seq);
	if (seq !== undefined && seq !== false) {
		ctrl.seq = seq;
	}
	ctrl.layout();
	//FastClick.attach(document.body);
};

ctrl.hasClass = function (t, className) {
	if (t.className.indexOf(className) === -1) {
		return false;
	} else {
		return true;
	}
};

ctrl.addClass = function (t, className) {

	t.className += ' ' + className;
};

ctrl.removeClass = function (t, className) {
	t.className = t.className.replace(className + ' ', '');
	t.className = t.className.replace(' ' + className, '');
};

Array.prototype.clone = function () {

	return this.slice(0);
};