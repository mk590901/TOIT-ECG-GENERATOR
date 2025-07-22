// Below is an example of a simple ECG signal generator in Toit
// creates a basic waveform with P, QRS and T waves using mathematical
// functions to simulate a typical ECG.
//
// This code:
// * Creates an ECG signal with a frequency of 60 bpm.
// * Uses Gaussian functions to simulate P, QRS and T waves.
// * Generates a signal with a duration of 2 seconds with a sampling rate of 256 Hz.
// * The QRS complex includes Q, R and S components with different amplitudes.
// * The result is a list of values representing the amplitude of the signal over time.

import math

// ECG parameters
HEART_RATE  ::= 60.0    // Heart rate (beats per minute)
SAMPLE_RATE ::= 256.0   // Sampling frequency (Hz)
DURATION    ::= 1.0     // Signal duration in seconds

// Wave amplitudes and durations
P_WAVE_AMP    ::= 0.2   // P-wave amplitude
QRS_AMP       ::= 1.0   // QRS complex amplitude
T_WAVE_AMP    ::= 0.3   // T-wave amplitude
P_DURATION    ::= 0.1   // P-wave duration
QRS_DURATION  ::= 0.1   // QRS complex duration
T_DURATION    ::= 0.2   // P-wave duration

// Noise
NOISE_PERSENT ::= 0.2   // Noise (persent from ECG signal value)

simple_rate -> int :
  return SAMPLE_RATE.to_int

generate_ecg -> List :
  ecg_signal := []
  period := 60.0 / HEART_RATE  // Period of one cardiac cycle
  samples := (DURATION * SAMPLE_RATE).to_int

  for i := 0; i < samples; i++:
    t := i / SAMPLE_RATE
    mod_t := t % period  // Time within one cycle

    signal := 0.0

    // P-wave (Gaussian function)
    p_center := 0.1 * period
    v1 := math.pow ((mod_t - p_center) / P_DURATION) 2
    signal += P_WAVE_AMP * (math.exp -v1)
    
    // QRS complex (combination of Gaussian functions)
    qrs_center := 0.4 * period
    v1 = math.pow ((mod_t - (qrs_center - 0.025)) / (QRS_DURATION / 3)) 2
    signal += -0.2 * QRS_AMP * (math.exp -v1)  // Q
    
    v1 = math.pow ((mod_t - qrs_center) / (QRS_DURATION / 2)) 2
    signal += QRS_AMP * (math.exp -v1)  // R

    v1 = math.pow ((mod_t - (qrs_center + 0.025)) / (QRS_DURATION / 3)) 2
    signal += -0.3 * QRS_AMP * (math.exp -v1)  // S

    // P-wave (Gaussian function)
    t_center := 0.7 * period    
    v1 = math.pow ((mod_t - t_center) / T_DURATION) 2
    signal += T_WAVE_AMP * (math.exp -v1)

    signal += noise signal

    ecg_signal.add signal

  return ecg_signal

noise signal/float :
   signal_int := (signal * 1000).to_int
   signal_int_noise_abs_value := (signal_int.to_float * NOISE_PERSENT).to_int
   signal_noise_random := random signal_int_noise_abs_value
   return signal_noise_random.to_float/1000
