flick_t++;
flick = 1 + sin(flick_t * 0.07) * 0.06 + random_range(-0.03, 0.03);

if (burst > 0) { burst--; flick *= 0.45; } // parpadeo breve
else if (irandom(240) == 0) burst = irandom_range(3, 8);