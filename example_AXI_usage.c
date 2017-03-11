
rotary_val = *My_rotary; //read rotary outside of IF (clears on read), *My_rotary is register connected to IP core block
if (rotary_val)
{
if (rotary_val & 0x01) //switch rising edge
	{
	xil_printf("Switch pressed\n");
	}
if ((rotary_val & 0x10)>>4) //right
	{
	count++;
	xil_printf("count:%d\n",count);
	}
if ((rotary_val & 0x20)>>5) //left
	{
	count--;
	xil_printf("count:%d\n",count);
	}
}
