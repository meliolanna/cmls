s.boot;

// Questo era quello di Youssef
(
SynthDef(\string, {arg out=0, freq=440, pan=0, sustain=0.5, amp=0.8, fil=12000;
	var pluck, period, string;
	pluck = PinkNoise.ar(Decay.kr(Impulse.kr(0), 0.05));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), fil)) * amp;
	DetectSilence.ar(string);
	Out.ar(out, string)
}).add;
).play;

//Youssef cambiando filtro QUESTO MI SEMBRA IL MIGLIORE
(
SynthDef(\stringR, {arg out=0, freq=324, pan=0, sustain=0.5, amp=0.8, fil=1200;
	var pluck, period, string;
	pluck = PinkNoise.ar(Decay.kr(Impulse.kr(0), 0.05));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(RLPF.ar(Pan2.ar(string, pan), fil)) * amp;
	DetectSilence.ar(string);
	Out.ar(out, string)
}).add;
).play;
(
r = Routine( {
	Synth(\stringR, [\freq, 83]);
	Synth(\stringR, [\freq, 123.47]);
	Synth(\stringR, [\freq, 146.83]);
	Synth(\stringR, [\freq, 196]);
	Synth(\stringR, [\freq, 246.94]);
	Synth(\stringR, [\freq, 392]);
});
// Queste le prove con il DynKlank

(
SynthDef(\string, {arg out=0, freq=440, pan=0, sustain=0.5, amp=0.4;
	var pluck, period, string, filter, signal;
	filter = freq*2.5;
	pluck = PinkNoise.ar(Decay.kr(Impulse.kr(0), 0.01));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), filter)) * amp;
	//freqs, ampls, decays
	signal = DynKlank.ar(`[[125, 171, 230], [0.1, 0.07, 0.05], [0.8,0.6,0.4]], string);
	DetectSilence.ar(string);
	Out.ar(out, signal);
}).add;
).play;

(
SynthDef(\string2, {arg out=0, freq=440, pan=0, sustain=0.5, amp=0.4;
	var pluck, period, string, filter, signal;
	filter = freq*2.5;
	pluck = PinkNoise.ar(Decay.kr(Impulse.kr(0), 0.01));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), filter)) * amp;
	//freqs, ampls, decays
	signal = DynKlank.ar(`[[freq/8, freq/4, freq/2], [0.1, 0.07, 0.05], [0.8,0.6,0.4]], string)*
	EnvGen.kr(
		Env( levels: [0.5,1,1], times: [0.1,0.5]);
	);
	DetectSilence.ar(string);
	Out.ar(out, signal);
}).add;
).play;

// Questo un altro coso trovato sull'internet che alla fine è uguale
(
SynthDef(\pluck, {arg freq=220, trig=1, time=2, coef=0.3, cutoff=15, pan=0;
    var pluck, burst, burstEnv;
    //burst = LPF.ar(WhiteNoise.ar(0.5), freq*cutoff);
    burstEnv = EnvGen.kr(Env.perc(0, 0.01));
    burst = RLPF.ar(WhiteNoise.ar(burstEnv), 1100, 0.900);
    pluck = CombL.ar(burst, 0.2, 0.003, 1.9, add: burst)*2;
    pluck = Pluck.ar(pluck, trig, freq.reciprocal, freq.reciprocal, time, coef:coef);
    Out.ar(0, Pan2.ar(pluck, pan));
}).add;
).play;

//note chitarra a vuoto. da risolvere il mi basso e il la, azzen
Pbind(\instrument, \pluck,
    \freq, Pseq([82.41, 110, 146.83,196, 246.94, 329.63], inf),
    \dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5], 1),
    \cutoff, Pseq([15, 15, 15, 15, 15, 15], 1)
).play
