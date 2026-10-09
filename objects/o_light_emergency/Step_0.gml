// Inherit the parent event
event_inherited();

// Respira lento: la luz crece y se apaga como una alarma moribunda
flick *= 0.7 + 0.3 * sin(flick_t * 0.04);