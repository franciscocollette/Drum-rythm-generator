

s.boot;
s.reboot;
s.quit;

Env([0,1,0],[1,1],[-2,2]).plot;

(
SynthDef.new(\kick, {
	arg freqA=1000, freqB=50, freqC=20, freqDur1=0.01, freqDur2=0.2, freqC1=1, freqC2=(-1),
	atk=0.01, rel=1, c1=1, c2=(-10), amp=0.8, pan=0, out=0;
	var sig, env, freqSweep;
	freqSweep = Env([freqA, freqB, freqC],[freqDur1, freqDur2], [freqC1, freqC2]).ar;
	env = Env([0,1,0],[atk,rel], [c1,c2]).kr(2);
	sig = SinOsc.ar(freqSweep, pi/2);
	sig = sig * env;
	sig = Pan2.ar(sig,pan,amp);
	Out.ar(out,sig);
}).add;
)

x = Synth.new(\kick, [\freqA, 500]);

Env([500,50,20],[0.01,0.2],[1,-1]).plot; // the kick envelope
Env([0,1,0],[0.01,1],[1,-10]).plot;   // the audio envelope

(
SynthDef(\snare, {
    |out = 0, pan = 0, amp = 0.3, freqA = 6000, freqB = 810, freqC = 150, freqDur1 = 0.005, freqDur2 = 0.01|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([freqA, freqB, freqC], [freqDur1, freqDur2], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.15), doneAction: 2);  // what does the doneAction: 2 ?? could be Done.freeSelf ?
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

   snd = (pop + noise) * 1.3;
  // snd = SinOsc.ar(popFreq);
    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;


)

Synth(\snare, [amp: 0.4, freqA: 500]);
Synth(\snare, [amp: 0.4, freqA: 6000]);

Env([6000,410,150],[0.005, 0.01],curve: \exp).plot;


(
SynthDef('\closedhat', {
	arg amp =1;
    var hatosc, hatenv, hatnoise, hatoutput;

    hatnoise = {LPF.ar(WhiteNoise.ar(1),9000)};

    hatosc = {HPF.ar(hatnoise,7000)};
    hatenv = {Line.ar(1, 0, 0.1)};

    hatoutput = (hatosc * hatenv);

    Out.ar(0,
    Pan2.ar(hatoutput, 0, amp)
    )

}).add;
)
Synth(\closedhat);



//       -------------------- kick quantities definition ---------------------
(
~kickDefinition={
var golpesRestantes = [];
var sumarGolpes = {};
var arrayRandom8kick={

var array=~cantidadCorcheas;
	var fixedElements = [0,2,4,6].reverseDo({arg item, i; array.removeAt(item)});
   // fixedElements;
	var mixing =array.scramble;
	mixing=mixing.insert(0,0);	mixing=mixing.insert(2,0);	mixing=mixing.insert(4,0);	mixing=mixing.insert(6,0);
	~cantidadCorcheas=mixing;
};

var arrayRandom16kick={

var array=~cantidadSemi;
	var fixedElements = [0,2,4,6,8,10,12,14].reverseDo({arg item, i; array.removeAt(item)});
   // fixedElements;
	var mixing =array.scramble;
	mixing=mixing.insert(0,0);	mixing=mixing.insert(2,0);	mixing=mixing.insert(4,0);	mixing=mixing.insert(6,0); mixing=mixing.insert(8,0); mixing=mixing.insert(10,0); mixing=mixing.insert(12,0); mixing=mixing.insert(14,0);
	~cantidadSemi=mixing;
};

///////////////////////////now I'll define the number of hits, and randomize them between the different figures
~nroGolpes = 2.rrand(6);   // first create the number of hits between 2 and 6
~nroGolpes;


~nroNegras = (~nroGolpes+1).rand.min(4);   //create a value between 0 and 4
~nroNegras;

~nroCorcheas = (~nroGolpes-~nroNegras+1).rand.min(4);  // create a value between 0 and number of hits availables, max 4
~nroCorcheas;

~nroSemi = (~nroGolpes-~nroNegras-~nroCorcheas+1).rand;  // create a value between 0 and number of hits availables
~nroSemi;


golpesRestantes = ~nroGolpes-~nroNegras-~nroCorcheas-~nroSemi;

sumarGolpes = {
var figElegida = [1,2,3].choose;
//figElegida.postln;
	    if(figElegida == 1, {if (~nroNegras<4, {~nroNegras = ~nroNegras+1}, {figElegida=[2,3].choose })});
    	if(figElegida == 2, {if (~nroCorcheas<4,{~nroCorcheas = ~nroCorcheas+1}, {figElegida=3}  )}) ;
		if(figElegida == 3, {~nroSemi = ~nroSemi+1})
		;
//	figElegida.postln;
};

while{golpesRestantes>0} {sumarGolpes.value; golpesRestantes = golpesRestantes-1;};


if (~nroNegras == 0, {~cantidadNegras = [0,0,0,0];});
if (~nroNegras == 1, {~cantidadNegras = [0,0,0,1];});
if (~nroNegras == 2, {~cantidadNegras = [0,0,1,1];});
if (~nroNegras == 3, {~cantidadNegras = [0,1,1,1];});
if (~nroNegras == 4, {~cantidadNegras = [1,1,1,1];});
//~cantidadNegras.postln;

if (~nroCorcheas == 0, {~cantidadCorcheas = [0,0,0,0,0,0,0,0];});
if (~nroCorcheas == 1, {~cantidadCorcheas = [0,0,0,0,0,0,0,1];});
if (~nroCorcheas == 2, {~cantidadCorcheas = [0,0,0,0,0,1,0,1];});
if (~nroCorcheas == 3, {~cantidadCorcheas = [0,0,0,1,0,1,0,1];});
if (~nroCorcheas == 4, {~cantidadCorcheas = [0,1,0,1,0,1,0,1];});
//~cantidadCorcheas.postln;

if (~nroSemi == 0, {~cantidadSemi = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0];});
if (~nroSemi == 1, {~cantidadSemi = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,1];});
if (~nroSemi == 2, {~cantidadSemi = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,1,0,1];});
if (~nroSemi == 3, {~cantidadSemi = [0,0,0,0,  0,0,0,0,  0,0,0,1,  0,1,0,1];});
if (~nroSemi == 4, {~cantidadSemi = [0,0,0,0,  0,0,0,0,  0,1,0,1,  0,1,0,1];});
if (~nroSemi == 5, {~cantidadSemi = [0,0,0,0,  0,0,0,1,  0,1,0,1,  0,1,0,1];});
if (~nroSemi == 6, {~cantidadSemi = [0,0,0,0,  0,1,0,1,  0,1,0,1,  0,1,0,1];});
//~cantidadSemi.postln;

("Kick total hits:" + ~nroGolpes).postln;
("quarter notes:" +~nroNegras).postln;
("8th notes:" +~nroCorcheas).postln;
("16th notes:"+~nroSemi).postln;


// ---------------  and kick patterns --------------

if (~nroNegras < 3 , {
	var array = ~cantidadNegras;
//array.postln;
var fixedElement = array.removeAt(1);
var arrayScrambled = array.scramble;
//arrayScrambled.postln;
arrayScrambled.insert(1,fixedElement);
arrayScrambled.postln;    // this is so when there are only 2 or 1 quarter notes, the second beat is never played
~cantidadNegras.insert(1,fixedElement);   //
n = Pbind (
	\instrument, \kick,
	\dur, 1,
	\freqA, 600,
	\atk, 0.01,
	\rel, 1,
	\amp, Pseq(arrayScrambled, inf),   //   esto es si hay 2 o 1 negras
	\out, 0
).play(quant:4);},
{
	var rythmNegras = ~cantidadNegras.scramble;
n = Pbind (
	\instrument, \kick,
	\dur, 1,                 //esto sera el tempo        -- Pseq([1,1],inf),
	\freqA, 600,
	\atk, 0.01,
	\rel, 1,
	\amp,  Pseq(rythmNegras, inf),   // esto es si hay 3 negras, se puede usar para todos igual
	\out, 0
).play(quant:4);
rythmNegras.postln;
}

);

arrayRandom8kick.value;
~cantidadCorcheas.postln;

//var newArrayCorcheas = ~cantidadCorcheas;

c = Pbind (
	\instrument, \kick,
	\dur, 0.5,
	\freqA, 550,
	\atk, 0.01,
	\rel, 1,
	\amp, Pseq(~cantidadCorcheas*0.7, inf),   //   esto es si hay 2 o 1 negras
	\out, 0
).play(quant:4);

arrayRandom16kick.value;
~cantidadSemi.postln;

z = Pbind (
	\instrument, \kick,
	\dur, 0.25,
	\freqA, 600,
	\atk, 0.01,
	\rel, 0.5,
	\amp, Pseq(~cantidadSemi*0.5, inf),   //   esto es si hay 2 o 1 negras
	\out, 0
).play(quant:4);
})




 //   -------------------- snares quantities definition ---------------------

(
~snareDefinition={
var golpesRestantes = [], sumarGolpes = {};

var arrayRandom4sn={

var array=~cantidadNegrasSn;
	var fixedElements = [0,2].reverseDo({arg item, i; array.removeAt(item)});
   // fixedElements;
	var mixing =array.scramble;
	mixing=mixing.insert(0,0);	mixing=mixing.insert(2,0);
	~cantidadNegrasSn=mixing;
};
var arrayRandom8sn={

var array=~cantidadCorcheasSn;
	var fixedElements = [0,2,4,6].reverseDo({arg item, i; array.removeAt(item)});
   // fixedElements;
	var mixing =array.scramble;
	mixing=mixing.insert(0,0);	mixing=mixing.insert(2,0);	mixing=mixing.insert(4,0);	mixing=mixing.insert(6,0);
	~cantidadCorcheasSn=mixing;
};
var arrayRandom16sn={

var array=~cantidadSemiSn;
	var fixedElements = [0,2,4,6,8,10,12,14].reverseDo({arg item, i; array.removeAt(item)});
   // fixedElements;
	var mixing =array.scramble;
	mixing=mixing.insert(0,0);	mixing=mixing.insert(2,0);	mixing=mixing.insert(4,0);	mixing=mixing.insert(6,0); mixing=mixing.insert(8,0); mixing=mixing.insert(10,0); mixing=mixing.insert(12,0); mixing=mixing.insert(14,0);
	~cantidadSemiSn=mixing;
};

~nroGolpesSn = 1.rrand(5);   // first create the number of hits between 2 and 6

~nroNegrasSn = (~nroGolpesSn+1).rand.min(2);   //create a value between 0 and 2

if(~nroGolpesSn>3, {
	~nroSemiSn = (~nroGolpesSn-~nroNegrasSn+1).rand.max(1)}, {
	~nroSemiSn = (~nroGolpesSn-~nroNegrasSn+1).rand} );
// create a value between 0 and number of hits availables

~nroCorcheasSn = (~nroGolpesSn-~nroNegrasSn-~nroSemiSn+1).rand.min(4); // create a value between 0 and number of hits availables, max 4

golpesRestantes = ~nroGolpesSn-~nroNegrasSn-~nroCorcheasSn-~nroSemiSn;

sumarGolpes = {
var figElegida = [1,2,3].choose;
//figElegida.postln;
	    if(figElegida == 1, {if (~nroNegrasSn<2, {~nroNegrasSn = ~nroNegrasSn+1}, {figElegida=[2,3].choose })});
    	if(figElegida == 2, {if (~nroCorcheasSn<4,{~nroCorcheasSn = ~nroCorcheasSn+1}, {figElegida=3}  )}) ;
		if(figElegida == 3, {~nroSemiSn = ~nroSemiSn+1})
		;
//	figElegida.postln;
};

while{golpesRestantes>0} {sumarGolpes.value; golpesRestantes = golpesRestantes-1;};

                                        /// define number of hits and allocate them in the different notes duration

if (~nroNegrasSn == 0, {~cantidadNegrasSn = [0,0,0,0];});
if (~nroNegrasSn == 1, {~cantidadNegrasSn = [0,0,0,1];});
if (~nroNegrasSn == 2, {~cantidadNegrasSn = [0,1,0,1];});
//~cantidadNegrasSn.postln;

if (~nroCorcheasSn == 0, {~cantidadCorcheasSn = [0,0,0,0,0,0,0,0];});
if (~nroCorcheasSn == 1, {~cantidadCorcheasSn = [0,0,0,0,0,0,0,1];});
if (~nroCorcheasSn == 2, {~cantidadCorcheasSn = [0,0,0,0,0,1,0,1];});
if (~nroCorcheasSn == 3, {~cantidadCorcheasSn = [0,0,0,1,0,1,0,1];});
if (~nroCorcheasSn == 4, {~cantidadCorcheasSn = [0,1,0,1,0,1,0,1];});
//~cantidadCorcheasSn.postln;

if (~nroSemiSn == 0, {~cantidadSemiSn = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0];});
if (~nroSemiSn == 1, {~cantidadSemiSn = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,1];});
if (~nroSemiSn == 2, {~cantidadSemiSn = [0,0,0,0,  0,0,0,0,  0,0,0,0,  0,1,0,1];});
if (~nroSemiSn == 3, {~cantidadSemiSn = [0,0,0,0,  0,0,0,0,  0,0,0,1,  0,1,0,1];});
if (~nroSemiSn == 4, {~cantidadSemiSn = [0,0,0,0,  0,0,0,0,  0,1,0,1,  0,1,0,1];});
if (~nroSemiSn == 5, {~cantidadSemiSn = [0,0,0,0,  0,0,0,1,  0,1,0,1,  0,1,0,1];});
if (~nroSemiSn == 6, {~cantidadSemiSn = [0,0,0,0,  0,1,0,1,  0,1,0,1,  0,1,0,1];});
//~cantidadSemiSn.postln;

("Snare total hits:" + ~nroGolpesSn).postln;
("quarter notes:" +~nroNegrasSn).postln;
("8th notes:" +~nroCorcheasSn).postln;
("16th notes:"+~nroSemiSn).postln;
                                              // then we run this to declare the 3 different arrays.
// ---------------  and snares patterns --------------

arrayRandom4sn.value;
~cantidadNegrasSn.postln;

~snQuarter = Pbind (
	\instrument, \snare,
	\dur, 1,
//	\freqA, 550,
//	\rel, 1,
	\amp, Pseq(~cantidadNegrasSn, inf),
	\out, 0
).play(quant:4);

arrayRandom8sn.value;
~cantidadCorcheasSn.postln;

~snEight = Pbind (
	\instrument, \snare,
	\dur, 0.5,
	\freqA, 550,
//	\rel, 1,
	\amp, Pseq(~cantidadCorcheasSn*0.8, inf),
	\out, 0
).play(quant:4);

arrayRandom16sn.value;
~cantidadSemiSn.postln;

~sn16th = Pbind (
	\instrument, \snare,
	\dur, 0.25,
	\freqA, 500,
//	\rel, 1,
	\amp, Pseq(~cantidadSemiSn*0.5, inf),
	\out, 0
).play(quant:4);
})


// ---------------------------- hihat quantities definition ---------------------------
(
~hihatDefinition={
var hatsMixed=[] ;
var loopLenght = [16,8,4].choose;
var minHits = (loopLenght/4).asInteger;
var hihatHits = rrand(minHits,loopLenght);
//hihatHits.postln;

var function = {
	var golpeAgregado;
	if (hihatHits > 0) {golpeAgregado=1}{golpeAgregado=0};
	hihatHits = hihatHits-1;
	golpeAgregado;

};
("hihat total hits:" + hihatHits).postln;
~cantidadHihats = Array.fill(loopLenght, { arg i; function.value });

// -------------------------------  hihat patterns --------------

hatsMixed=~cantidadHihats.scramble;
hatsMixed.postln;
~hihats = Pbind (
	\instrument, \closedhat,
	\dur, 0.25,
//	\freqA, 10000,
//	\freqB, 5000,
//	\freqC, 2000,
	// freqB = 810, freqC = 150, freqDur1 = 0.005, freqDur2 = 0.01
	\amp, Pseq(hatsMixed, inf),
	\out, 0
).play(quant:4);
})



// -------------------- play... ------------


(~metroDef= {
~metronome = Pbind (
	\instrument, \snare,
	\dur, 1,
	\freqA, 10000,
	\freqB, 5000,
	\freqC, 2000,
	// freqB = 810, freqC = 150, freqDur1 = 0.005, freqDur2 = 0.01
	\amp, Pseq([0.4,0.1,0.1,0.1], inf),
	\out, 0
	).play(quant:4);
});

~metroDef.value;
~metronome.play(quant:4);
(~metronome.pause;
~metronome.reset;)

(~snQuarter.stop ;
~snEight.stop ;
~sn16th.stop ;
~snareDefinition.value;)

(~hihats.stop;
~hihatDefinition.value;)

(n.stop;
c.stop;
z.stop;
~kickDefinition.value;)
//create 3 buttons, when pressed, each of this functions are evaluated, creating a new pattern.

(
n.play(quant: 4);
c.play(quant: 4) ;
z.play(quant: 4)  ;

~snQuarter.play(quant: 4) ;
~snEight.play(quant: 4) ;
~sn16th.play(quant:4) ;

~hihats.play(quant:4);
//~metronome.play(quant:4);
)                                        // add 1 button to play all togheter

~hihats.mute;
~hihats.unmute;

(~snQuarter.mute ;
~snEight.mute ;
~sn16th.mute ;)
(~snQuarter.unmute ;
~snEight.unmute ;
~sn16th.unmute;)

(n.mute;
c.mute;
z.mute;)
(n.unmute;
c.unmute ;
z.unmute ;)

//create 3 buttons to play or silence each of the instruments

