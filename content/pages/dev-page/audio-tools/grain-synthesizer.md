---
title: "Granular Synth Exploration Tool"
tags: [signal flow design, audio processing, grain synthesis, machine learning, max msp]
thumbnail: "/img/thumbnails/grain-synth-thumbnail.webp"
download: "/audio-tools/fx-tools/JL_Grain Synthesizer.zip"
video: https://content.jakoblundoe.com/grain-synth-videodemo-v1.mp4
order: 0
---
### A grain synthesizer controller by a XY pad
This tool includes an audio grain synth generator and a machine-learning-based controller. It is an exploration of grain synthesis and the use of machine learning to create expressive, intuitive controller mappings. These controller mappings are not only designed to simplify control over an extensive set of parameters, but also expand the synthesizer’s potential and the sound exploration process.

#### The grain synthesizer element
The generator is built on the core concepts of grain synthesis and is controlled by multiple parameters (grain size, curve, spread, sample travel, etc.). It includes two voices and can generate grains from two samples simultaneously.

#### The controller element
The controller element uses machine learning to link the grain synthesizer’s parameters to the XY controller in interesting (and unplanned) ways. It requires the FluCoMa library for Max MSP to run it.

#### A note
I created this patch as part of an exploration, so it isn’t packaged neatly, but I may build a proper UI for it in the future. Feel free to download, use, and modify it as you like.