# QueueMetrics <-> CallCabinet integration

This repository contains resources that are useful for the integration between Loway's QueueMetrics and Atmos' CallCabinet. These files are provided for historical interest only, as QueueMetrics **does not support CallCabinet natively** - if you need a privacy-first way to sore and retrieve recordings, see AudioVault: https://www.queuemetrics.com/blog/2021/08/25/AudioVault-tutorial/

## Contents

- **Moverec Script**: A slightly modified version of Atmos' moverec.sh script. This script moves Asterisk recordings from the original recording folder to CallCabinet's staging folder, renaming the file in such a format as to be presenting all the information that are needed for a QueueMetrics compatible storing on CallCabinet's repository.

- **Integration Guide**: This document details the setup needed to setup the integration between the two softwares. This way, from its QueueMetrics reports, a user can acces Asterisk recordings that are stored in the CallCabinet repository.
