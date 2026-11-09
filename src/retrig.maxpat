{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 9,
			"minor": 0,
			"revision": 4,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "box",
		"rect": [
			60.0,
			100.0,
			1300.0,
			940.0
		],
		"openrect": [
			0.0,
			0.0,
			330.0,
			169.0
		],
		"bglocked": 0,
		"openinpresentation": 1,
		"default_fontsize": 10.0,
		"default_fontface": 0,
		"default_fontname": "Arial Bold",
		"gridonopen": 1,
		"gridsize": [
			8.0,
			8.0
		],
		"gridsnaponopen": 1,
		"objectsnaponopen": 1,
		"statusbarvisible": 2,
		"toolbarvisible": 1,
		"boxanimatetime": 500,
		"enablehscroll": 1,
		"enablevscroll": 1,
		"devicewidth": 330.0,
		"description": "Elektron-style per-pad retrig for Drum Rack chains.",
		"digest": "",
		"tags": "",
		"style": "",
		"subpatcher_template": "",
		"title": "Retrig",
		"boxes": [
			{
				"box": {
					"id": "c-title",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						4.0,
						620.0,
						20.0
					],
					"text": "RETRIG v3 - per-pad retrig (RTRG / RATE / LEN / VFAD / CRV / PROB / LOCK, Setup: PMODE). All timing in the Max scheduler: no JS.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 1
				}
			},
			{
				"box": {
					"id": "c-in",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						26.0,
						520.0,
						20.0
					],
					"text": "1. MIDI in. Non-note messages go straight through midiformat. Notes go to the RTRG gate.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 1
				}
			},
			{
				"box": {
					"id": "c-gate",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						136.0,
						560.0,
						20.0
					],
					"text": "2. RTRG gate: off -> left outlet passes notes through unchanged; on -> right outlet feeds the retrig engine.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 1
				}
			},
			{
				"box": {
					"id": "c-on",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						226.0,
						620.0,
						20.0
					],
					"text": "3. Note-on only (stripnote drops note-offs: the engine owns its note-offs). Order: kill old burst, store pitch/vel, start.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 1
				}
			},
			{
				"box": {
					"id": "c-start",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						356.0,
						700.0,
						34.0
					],
					"text": "4. Start: reset hit index, look up RATE ticks (sets metro interval) and LEN half-ticks, N = ceil(LEN/RATE) (0 = INF), then start metro. Values are latched here.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 2
				}
			},
			{
				"box": {
					"id": "c-int",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						330.0,
						520.0,
						380.0,
						34.0
					],
					"text": "5. Interval: transport playing -> 'interval N ticks' (follows tempo). Stopped -> converted to ms at the current tempo.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 2
				}
			},
			{
				"box": {
					"id": "c-hit",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						640.0,
						560.0,
						20.0
					],
					"text": "6. Each metro bang: note-off for the previous hit, then if i < N (or N = 0): note-on, else stop.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 1
				}
			},
			{
				"box": {
					"id": "c-flush",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						560.0,
						640.0,
						360.0,
						20.0
					],
					"text": "7. Flush: note-off for the sounding pitch (-1 = nothing sounding; sel -1 drops it). No moses: it breaks loading on Push standalone.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 1
				}
			},
			{
				"box": {
					"id": "c-kill",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						560.0,
						300.0,
						330.0,
						34.0
					],
					"text": "Kill = stop metro + flush. Called by: new note, RTRG change, transport stop.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 2
				}
			},
			{
				"box": {
					"id": "c-rtrg",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						700.0,
						26.0,
						330.0,
						48.0
					],
					"text": "RTRG change: kill burst, note-off for the last incoming pitch (in case a passed-through note was held), switch gate.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 3
				}
			},
			{
				"box": {
					"id": "c-tr",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						960.0,
						380.0,
						300.0,
						34.0
					],
					"text": "Transport state from the Live API (low priority, only used for stop + interval mode).",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 2
				}
			},
			{
				"box": {
					"id": "c-dbg",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						960.0,
						640.0,
						300.0,
						34.0
					],
					"text": "Debug: turn on to print every note and burst size to the Max console.",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 2
				}
			},
			{
				"box": {
					"id": "midiin",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						50.0,
						52.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "midiin",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "parse",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 7,
					"patching_rect": [
						20.0,
						80.0,
						440.0,
						20.0
					],
					"outlettype": [
						"",
						"",
						"",
						"int",
						"int",
						"int",
						"int"
					],
					"text": "midiparse",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "format",
					"maxclass": "newobj",
					"numinlets": 7,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						860.0,
						440.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "midiformat",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "midiout",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						890.0,
						59.0,
						20.0
					],
					"outlettype": [],
					"text": "midiout",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-in",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						20.0,
						110.0,
						45.0,
						20.0
					],
					"outlettype": [
						"",
						""
					],
					"text": "t l l",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "unp-last",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						120.0,
						140.0,
						80.0,
						20.0
					],
					"outlettype": [
						"int",
						"int"
					],
					"text": "unpack 0 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "i-last",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						120.0,
						170.0,
						38.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "i -1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "gate-rtrg",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						20.0,
						170.0,
						52.0,
						20.0
					],
					"outlettype": [
						"",
						""
					],
					"text": "gate 2",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "RTRG",
					"maxclass": "live.toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						700.0,
						80.0,
						15.0,
						15.0
					],
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"varname": "RTRG",
					"presentation": 1,
					"presentation_rect": [
						10.0,
						26.0,
						15.0,
						15.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "RTRG",
							"parameter_shortname": "RTRG",
							"parameter_type": 2,
							"parameter_mmax": 1.0,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_initial_enable": 1,
							"parameter_initial": [
								1
							],
							"parameter_annotation_name": "Retrig on/off"
						}
					}
				}
			},
			{
				"box": {
					"id": "t-rtrg",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						700.0,
						110.0,
						59.0,
						20.0
					],
					"outlettype": [
						"int",
						"bang",
						"bang"
					],
					"text": "t i b b",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "plus-rtrg",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						700.0,
						140.0,
						31.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "sel-last",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						760.0,
						170.0,
						59.0,
						20.0
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel -1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "strip",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						160.0,
						250.0,
						73.0,
						20.0
					],
					"outlettype": [
						"int",
						"int"
					],
					"text": "stripnote",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "pack-in",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						160.0,
						280.0,
						66.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "pack 0 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-note",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						160.0,
						310.0,
						59.0,
						20.0
					],
					"outlettype": [
						"bang",
						"",
						"bang"
					],
					"text": "t b l b",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "unp-note",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						280.0,
						340.0,
						80.0,
						20.0
					],
					"outlettype": [
						"int",
						"int"
					],
					"text": "unpack 0 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "i-pitch",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						280.0,
						720.0,
						30.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "i-vel",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						340.0,
						720.0,
						30.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-kill",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						560.0,
						340.0,
						45.0,
						20.0
					],
					"outlettype": [
						"bang",
						"bang"
					],
					"text": "t b b",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-stop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						620.0,
						370.0,
						38.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "stop",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-start",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 5,
					"patching_rect": [
						20.0,
						400.0,
						73.0,
						20.0
					],
					"outlettype": [
						"bang",
						"bang",
						"bang",
						"bang",
						"bang"
					],
					"text": "t b b b b b",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-zero",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						260.0,
						430.0,
						30.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "RATE",
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						700.0,
						420.0,
						56.0,
						15.0
					],
					"outlettype": [
						"",
						"",
						"float"
					],
					"parameter_enable": 1,
					"varname": "RATE",
					"presentation": 1,
					"presentation_rect": [
						44.0,
						26.0,
						52.0,
						15.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "RATE",
							"parameter_shortname": "RATE",
							"parameter_type": 2,
							"parameter_enum": [
								"1/1",
								"1/2",
								"1/3",
								"1/4",
								"1/5",
								"1/6",
								"1/8",
								"1/10",
								"1/12",
								"1/16",
								"1/20",
								"1/24",
								"1/32",
								"1/40",
								"1/48",
								"1/64",
								"1/80"
							],
							"parameter_mmax": 16.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								9
							],
							"parameter_annotation_name": "Retrig rate (synced to Live's tempo)"
						}
					}
				}
			},
			{
				"box": {
					"id": "i-rate",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						180.0,
						460.0,
						30.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "coll-rate",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						180.0,
						490.0,
						94.0,
						20.0
					],
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"text": "coll ---rate",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"saved_object_attributes": {
						"embed": 1,
						"precision": 6
					},
					"coll_data": {
						"count": 17,
						"data": [
							{
								"key": 0,
								"value": [
									1920
								]
							},
							{
								"key": 1,
								"value": [
									960
								]
							},
							{
								"key": 2,
								"value": [
									640
								]
							},
							{
								"key": 3,
								"value": [
									480
								]
							},
							{
								"key": 4,
								"value": [
									384
								]
							},
							{
								"key": 5,
								"value": [
									320
								]
							},
							{
								"key": 6,
								"value": [
									240
								]
							},
							{
								"key": 7,
								"value": [
									192
								]
							},
							{
								"key": 8,
								"value": [
									160
								]
							},
							{
								"key": 9,
								"value": [
									120
								]
							},
							{
								"key": 10,
								"value": [
									96
								]
							},
							{
								"key": 11,
								"value": [
									80
								]
							},
							{
								"key": 12,
								"value": [
									60
								]
							},
							{
								"key": 13,
								"value": [
									48
								]
							},
							{
								"key": 14,
								"value": [
									40
								]
							},
							{
								"key": 15,
								"value": [
									30
								]
							},
							{
								"key": 16,
								"value": [
									24
								]
							}
						]
					}
				}
			},
			{
				"box": {
					"id": "t-rate",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						180.0,
						520.0,
						45.0,
						20.0
					],
					"outlettype": [
						"int",
						"int"
					],
					"text": "t i i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "LEN",
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						780.0,
						420.0,
						56.0,
						15.0
					],
					"outlettype": [
						"",
						"",
						"float"
					],
					"parameter_enable": 1,
					"varname": "LEN",
					"presentation": 1,
					"presentation_rect": [
						104.0,
						26.0,
						52.0,
						15.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "LEN",
							"parameter_shortname": "LEN",
							"parameter_type": 2,
							"parameter_enum": [
								"0.125",
								"0.188",
								"1/64",
								"0.313",
								"0.375",
								"0.438",
								"1/32",
								"0.563",
								"0.625",
								"0.688",
								"0.750",
								"0.813",
								"0.875",
								"0.938",
								"1/16",
								"1.06",
								"1.13",
								"1.19",
								"1.25",
								"1.31",
								"1.38",
								"1.44",
								"1.50",
								"1.56",
								"1.63",
								"1.69",
								"1.75",
								"1.81",
								"1.88",
								"1.94",
								"1/8",
								"2.13",
								"2.25",
								"2.38",
								"2.50",
								"2.63",
								"2.75",
								"2.88",
								"3.00",
								"3.13",
								"3.25",
								"3.38",
								"3.50",
								"3.63",
								"3.75",
								"3.88",
								"1/4",
								"4.25",
								"4.50",
								"4.75",
								"5.00",
								"5.25",
								"5.50",
								"5.75",
								"6.00",
								"6.25",
								"6.50",
								"6.75",
								"7.00",
								"7.25",
								"7.50",
								"7.75",
								"1/2",
								"8.50",
								"9.00",
								"9.50",
								"10.0",
								"10.5",
								"11.0",
								"11.5",
								"12.0",
								"12.5",
								"13.0",
								"13.5",
								"14.0",
								"14.5",
								"15.0",
								"15.5",
								"1/1",
								"17.0",
								"18.0",
								"19.0",
								"20.0",
								"21.0",
								"22.0",
								"23.0",
								"24.0",
								"25.0",
								"26.0",
								"27.0",
								"28.0",
								"29.0",
								"30.0",
								"31.0",
								"32.0",
								"34.0",
								"36.0",
								"38.0",
								"40.0",
								"42.0",
								"44.0",
								"46.0",
								"48.0",
								"50.0",
								"52.0",
								"54.0",
								"56.0",
								"58.0",
								"60.0",
								"62.0",
								"64.0",
								"68.0",
								"72.0",
								"76.0",
								"80.0",
								"84.0",
								"88.0",
								"92.0",
								"96.0",
								"100",
								"104",
								"108",
								"112",
								"116",
								"120",
								"124",
								"128",
								"INF"
							],
							"parameter_mmax": 127.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								46
							],
							"parameter_annotation_name": "Burst length in steps (1 step = 1/16)"
						}
					}
				}
			},
			{
				"box": {
					"id": "i-len",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						100.0,
						460.0,
						30.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "coll-len",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						100.0,
						550.0,
						87.0,
						20.0
					],
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"text": "coll ---len",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"saved_object_attributes": {
						"embed": 1,
						"precision": 6
					},
					"coll_data": {
						"count": 128,
						"data": [
							{
								"key": 0,
								"value": [
									30
								]
							},
							{
								"key": 1,
								"value": [
									45
								]
							},
							{
								"key": 2,
								"value": [
									60
								]
							},
							{
								"key": 3,
								"value": [
									75
								]
							},
							{
								"key": 4,
								"value": [
									90
								]
							},
							{
								"key": 5,
								"value": [
									105
								]
							},
							{
								"key": 6,
								"value": [
									120
								]
							},
							{
								"key": 7,
								"value": [
									135
								]
							},
							{
								"key": 8,
								"value": [
									150
								]
							},
							{
								"key": 9,
								"value": [
									165
								]
							},
							{
								"key": 10,
								"value": [
									180
								]
							},
							{
								"key": 11,
								"value": [
									195
								]
							},
							{
								"key": 12,
								"value": [
									210
								]
							},
							{
								"key": 13,
								"value": [
									225
								]
							},
							{
								"key": 14,
								"value": [
									240
								]
							},
							{
								"key": 15,
								"value": [
									255
								]
							},
							{
								"key": 16,
								"value": [
									270
								]
							},
							{
								"key": 17,
								"value": [
									285
								]
							},
							{
								"key": 18,
								"value": [
									300
								]
							},
							{
								"key": 19,
								"value": [
									315
								]
							},
							{
								"key": 20,
								"value": [
									330
								]
							},
							{
								"key": 21,
								"value": [
									345
								]
							},
							{
								"key": 22,
								"value": [
									360
								]
							},
							{
								"key": 23,
								"value": [
									375
								]
							},
							{
								"key": 24,
								"value": [
									390
								]
							},
							{
								"key": 25,
								"value": [
									405
								]
							},
							{
								"key": 26,
								"value": [
									420
								]
							},
							{
								"key": 27,
								"value": [
									435
								]
							},
							{
								"key": 28,
								"value": [
									450
								]
							},
							{
								"key": 29,
								"value": [
									465
								]
							},
							{
								"key": 30,
								"value": [
									480
								]
							},
							{
								"key": 31,
								"value": [
									510
								]
							},
							{
								"key": 32,
								"value": [
									540
								]
							},
							{
								"key": 33,
								"value": [
									570
								]
							},
							{
								"key": 34,
								"value": [
									600
								]
							},
							{
								"key": 35,
								"value": [
									630
								]
							},
							{
								"key": 36,
								"value": [
									660
								]
							},
							{
								"key": 37,
								"value": [
									690
								]
							},
							{
								"key": 38,
								"value": [
									720
								]
							},
							{
								"key": 39,
								"value": [
									750
								]
							},
							{
								"key": 40,
								"value": [
									780
								]
							},
							{
								"key": 41,
								"value": [
									810
								]
							},
							{
								"key": 42,
								"value": [
									840
								]
							},
							{
								"key": 43,
								"value": [
									870
								]
							},
							{
								"key": 44,
								"value": [
									900
								]
							},
							{
								"key": 45,
								"value": [
									930
								]
							},
							{
								"key": 46,
								"value": [
									960
								]
							},
							{
								"key": 47,
								"value": [
									1020
								]
							},
							{
								"key": 48,
								"value": [
									1080
								]
							},
							{
								"key": 49,
								"value": [
									1140
								]
							},
							{
								"key": 50,
								"value": [
									1200
								]
							},
							{
								"key": 51,
								"value": [
									1260
								]
							},
							{
								"key": 52,
								"value": [
									1320
								]
							},
							{
								"key": 53,
								"value": [
									1380
								]
							},
							{
								"key": 54,
								"value": [
									1440
								]
							},
							{
								"key": 55,
								"value": [
									1500
								]
							},
							{
								"key": 56,
								"value": [
									1560
								]
							},
							{
								"key": 57,
								"value": [
									1620
								]
							},
							{
								"key": 58,
								"value": [
									1680
								]
							},
							{
								"key": 59,
								"value": [
									1740
								]
							},
							{
								"key": 60,
								"value": [
									1800
								]
							},
							{
								"key": 61,
								"value": [
									1860
								]
							},
							{
								"key": 62,
								"value": [
									1920
								]
							},
							{
								"key": 63,
								"value": [
									2040
								]
							},
							{
								"key": 64,
								"value": [
									2160
								]
							},
							{
								"key": 65,
								"value": [
									2280
								]
							},
							{
								"key": 66,
								"value": [
									2400
								]
							},
							{
								"key": 67,
								"value": [
									2520
								]
							},
							{
								"key": 68,
								"value": [
									2640
								]
							},
							{
								"key": 69,
								"value": [
									2760
								]
							},
							{
								"key": 70,
								"value": [
									2880
								]
							},
							{
								"key": 71,
								"value": [
									3000
								]
							},
							{
								"key": 72,
								"value": [
									3120
								]
							},
							{
								"key": 73,
								"value": [
									3240
								]
							},
							{
								"key": 74,
								"value": [
									3360
								]
							},
							{
								"key": 75,
								"value": [
									3480
								]
							},
							{
								"key": 76,
								"value": [
									3600
								]
							},
							{
								"key": 77,
								"value": [
									3720
								]
							},
							{
								"key": 78,
								"value": [
									3840
								]
							},
							{
								"key": 79,
								"value": [
									4080
								]
							},
							{
								"key": 80,
								"value": [
									4320
								]
							},
							{
								"key": 81,
								"value": [
									4560
								]
							},
							{
								"key": 82,
								"value": [
									4800
								]
							},
							{
								"key": 83,
								"value": [
									5040
								]
							},
							{
								"key": 84,
								"value": [
									5280
								]
							},
							{
								"key": 85,
								"value": [
									5520
								]
							},
							{
								"key": 86,
								"value": [
									5760
								]
							},
							{
								"key": 87,
								"value": [
									6000
								]
							},
							{
								"key": 88,
								"value": [
									6240
								]
							},
							{
								"key": 89,
								"value": [
									6480
								]
							},
							{
								"key": 90,
								"value": [
									6720
								]
							},
							{
								"key": 91,
								"value": [
									6960
								]
							},
							{
								"key": 92,
								"value": [
									7200
								]
							},
							{
								"key": 93,
								"value": [
									7440
								]
							},
							{
								"key": 94,
								"value": [
									7680
								]
							},
							{
								"key": 95,
								"value": [
									8160
								]
							},
							{
								"key": 96,
								"value": [
									8640
								]
							},
							{
								"key": 97,
								"value": [
									9120
								]
							},
							{
								"key": 98,
								"value": [
									9600
								]
							},
							{
								"key": 99,
								"value": [
									10080
								]
							},
							{
								"key": 100,
								"value": [
									10560
								]
							},
							{
								"key": 101,
								"value": [
									11040
								]
							},
							{
								"key": 102,
								"value": [
									11520
								]
							},
							{
								"key": 103,
								"value": [
									12000
								]
							},
							{
								"key": 104,
								"value": [
									12480
								]
							},
							{
								"key": 105,
								"value": [
									12960
								]
							},
							{
								"key": 106,
								"value": [
									13440
								]
							},
							{
								"key": 107,
								"value": [
									13920
								]
							},
							{
								"key": 108,
								"value": [
									14400
								]
							},
							{
								"key": 109,
								"value": [
									14880
								]
							},
							{
								"key": 110,
								"value": [
									15360
								]
							},
							{
								"key": 111,
								"value": [
									16320
								]
							},
							{
								"key": 112,
								"value": [
									17280
								]
							},
							{
								"key": 113,
								"value": [
									18240
								]
							},
							{
								"key": 114,
								"value": [
									19200
								]
							},
							{
								"key": 115,
								"value": [
									20160
								]
							},
							{
								"key": 116,
								"value": [
									21120
								]
							},
							{
								"key": 117,
								"value": [
									22080
								]
							},
							{
								"key": 118,
								"value": [
									23040
								]
							},
							{
								"key": 119,
								"value": [
									24000
								]
							},
							{
								"key": 120,
								"value": [
									24960
								]
							},
							{
								"key": 121,
								"value": [
									25920
								]
							},
							{
								"key": 122,
								"value": [
									26880
								]
							},
							{
								"key": 123,
								"value": [
									27840
								]
							},
							{
								"key": 124,
								"value": [
									28800
								]
							},
							{
								"key": 125,
								"value": [
									29760
								]
							},
							{
								"key": 126,
								"value": [
									30720
								]
							},
							{
								"key": 127,
								"value": [
									0
								]
							}
						]
					}
				}
			},
			{
				"box": {
					"id": "expr-n",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						100.0,
						580.0,
						200.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "expr ($i1 + 2 * $i2 - 1) / (2 * $i2)",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "gate-int",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						330.0,
						560.0,
						66.0,
						20.0
					],
					"outlettype": [
						"",
						""
					],
					"text": "gate 2 1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "translate",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						330.0,
						590.0,
						170.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "translate ticks ms @listen 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-int-ms",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						330.0,
						615.0,
						87.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "interval $1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-int-ticks",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						460.0,
						615.0,
						110.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "interval $1 ticks",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-go",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						660.0,
						30.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "metro",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						690.0,
						73.0,
						20.0
					],
					"outlettype": [
						"bang"
					],
					"text": "metro 100",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-hit",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						20.0,
						720.0,
						45.0,
						20.0
					],
					"outlettype": [
						"bang",
						"bang"
					],
					"text": "t b b",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "i-idx",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						750.0,
						31.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "i 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-idx",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						20.0,
						775.0,
						45.0,
						20.0
					],
					"outlettype": [
						"int",
						"int",
						"int",
						"int"
					],
					"text": "t i i i i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "plus-idx",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						100.0,
						775.0,
						31.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "expr-play",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						800.0,
						180.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "expr ($i2 == 0) || ($i1 < $i2)",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "sel-play",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						20.0,
						825.0,
						45.0,
						20.0
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-play",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						220.0,
						825.0,
						45.0,
						20.0
					],
					"outlettype": [
						"bang"
					],
					"text": "t b",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-pitch",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						280.0,
						750.0,
						45.0,
						20.0
					],
					"outlettype": [
						"int",
						"int"
					],
					"text": "t i i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "pack-on",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						280.0,
						800.0,
						66.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "pack 0 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "i-sound",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						560.0,
						720.0,
						38.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "i -1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "sel-sound",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						560.0,
						750.0,
						59.0,
						20.0
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel -1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-flush",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						620.0,
						780.0,
						45.0,
						20.0
					],
					"outlettype": [
						"bang",
						"int"
					],
					"text": "t b i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "pack-off",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						620.0,
						820.0,
						66.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "pack 0 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-none",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						560.0,
						810.0,
						30.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "-1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "thisdev",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						960.0,
						420.0,
						115.0,
						20.0
					],
					"outlettype": [
						"bang",
						"int",
						"int"
					],
					"text": "live.thisdevice",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "t-dev",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						960.0,
						450.0,
						45.0,
						20.0
					],
					"outlettype": [
						"bang",
						"bang"
					],
					"text": "t b b",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-prop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1040.0,
						480.0,
						120.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "property is_playing",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "m-path",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						960.0,
						480.0,
						90.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "path live_set",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "lpath",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						960.0,
						510.0,
						73.0,
						20.0
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "live.path",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "observer",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						960.0,
						540.0,
						101.0,
						20.0
					],
					"outlettype": [
						"",
						""
					],
					"text": "live.observer",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"saved_object_attributes": {
						"_persistence": 0
					}
				}
			},
			{
				"box": {
					"id": "t-play-state",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						960.0,
						570.0,
						45.0,
						20.0
					],
					"outlettype": [
						"int",
						"int"
					],
					"text": "t i i",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "plus-state",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1040.0,
						600.0,
						31.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "sel-stop",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						960.0,
						600.0,
						45.0,
						20.0
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 0",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "dbg-toggle",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						960.0,
						680.0,
						20.0,
						20.0
					],
					"outlettype": [
						"int"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "dbg-gate",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						960.0,
						770.0,
						38.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "gate",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "pre-note",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1040.0,
						710.0,
						94.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "prepend note",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "pre-burst",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1140.0,
						710.0,
						110.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "prepend burst_hits",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "print",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						960.0,
						800.0,
						94.0,
						20.0
					],
					"outlettype": [],
					"text": "print retrig",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "banks",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						960.0,
						860.0,
						80.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "live.banks",
					"fontname": "Arial Bold",
					"fontsize": 10.0
				}
			},
			{
				"box": {
					"id": "c-banks",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1040.0,
						860.0,
						300.0,
						34.0
					],
					"text": "Push bank 'Retrig' is stored in the device (patcher parameters -> parameterbanks).",
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"linecount": 2
				}
			},
			{
				"box": {
					"id": "lbl-rtrg",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1100.0,
						86.0,
						40.0,
						18.0
					],
					"text": "RTRG",
					"presentation": 1,
					"presentation_rect": [
						6.0,
						8.0,
						40.0,
						18.0
					],
					"textjustification": 0
				}
			},
			{
				"box": {
					"id": "lbl-rate",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1100.0,
						124.0,
						40.0,
						18.0
					],
					"text": "RATE",
					"presentation": 1,
					"presentation_rect": [
						44.0,
						8.0,
						40.0,
						18.0
					],
					"textjustification": 0
				}
			},
			{
				"box": {
					"id": "lbl-len",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1100.0,
						184.0,
						40.0,
						18.0
					],
					"text": "LEN",
					"presentation": 1,
					"presentation_rect": [
						104.0,
						8.0,
						40.0,
						18.0
					],
					"textjustification": 0
				}
			},
			{
				"box": {
					"id": "VFAD",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"varname": "VFAD",
					"patching_rect": [
						860.0,
						440.0,
						44.0,
						47.0
					],
					"presentation": 1,
					"presentation_rect": [
						160.0,
						4.0,
						44.0,
						47.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "VFAD",
							"parameter_shortname": "VFAD",
							"parameter_type": 0,
							"parameter_unitstyle": 5,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.0
							],
							"parameter_annotation_name": "Velocity fade: -100% down to 1, +100% up to 127"
						}
					}
				}
			},
			{
				"box": {
					"id": "CRV",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"varname": "CRV",
					"patching_rect": [
						920.0,
						440.0,
						44.0,
						47.0
					],
					"presentation": 1,
					"presentation_rect": [
						208.0,
						4.0,
						44.0,
						47.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "CRV",
							"parameter_shortname": "CRV",
							"parameter_type": 0,
							"parameter_unitstyle": 5,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.0
							],
							"parameter_annotation_name": "Fade curve: 0% linear, 100% exponential"
						}
					}
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "f-vfad",
					"maxclass": "newobj",
					"text": "f",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						860.0,
						500.0,
						30.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "f-crv",
					"maxclass": "newobj",
					"text": "f",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						920.0,
						500.0,
						30.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "t-vsetup",
					"maxclass": "newobj",
					"text": "t b b b b b",
					"numinlets": 1,
					"numoutlets": 5,
					"outlettype": [
						"bang",
						"bang",
						"bang",
						"bang",
						"bang"
					],
					"patching_rect": [
						420.0,
						430.0,
						59.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "t-v0",
					"maxclass": "newobj",
					"text": "t f f",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"float",
						"float"
					],
					"patching_rect": [
						420.0,
						470.0,
						45.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "expr-ve",
					"maxclass": "newobj",
					"text": "expr $f1 + max($f2 / 100. * ($f3 > 0), 0.) * (127. - $f1) + min($f2 / 100. * ($f3 > 0), 0.) * ($f1 - 1.)",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						420.0,
						500.0,
						520.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "expr-t",
					"maxclass": "newobj",
					"text": "expr min(1., $i1 / max($f2 - 1., 1.))",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						140.0,
						860.0,
						230.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "expr-vel",
					"maxclass": "newobj",
					"text": "expr min(127, max(1, int((1. - $f4 / 100.) * ($f2 + ($f3 - $f2) * $f1) + $f4 / 100. * $f2 * pow($f3 / $f2, $f1) + 0.5)))",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						140.0,
						890.0,
						640.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "c-vel",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"text": "8. Velocity. Note-on: ve = end velocity from v0 and VFAD (-100% -> 1, +100% -> 127; INF = no fade). Each hit: t = i / (N - 1), so the fade lands exactly on the last hit; v = CRV blend of linear and exponential v0 -> ve, rounded, 1-127.",
					"patching_rect": [
						140.0,
						920.0,
						640.0,
						48.0
					],
					"linecount": 3
				}
			},
			{
				"box": {
					"id": "PROB",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"varname": "PROB",
					"patching_rect": [
						1040.0,
						440.0,
						44.0,
						47.0
					],
					"presentation": 1,
					"presentation_rect": [
						256.0,
						4.0,
						44.0,
						47.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "PROB",
							"parameter_shortname": "PROB",
							"parameter_type": 0,
							"parameter_unitstyle": 5,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100.0
							],
							"parameter_annotation_name": "Chance that retriggers fire (see PMODE)"
						}
					}
				}
			},
			{
				"box": {
					"id": "LOCK",
					"maxclass": "live.toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"varname": "LOCK",
					"patching_rect": [
						1100.0,
						440.0,
						15.0,
						15.0
					],
					"presentation": 1,
					"presentation_rect": [
						306.0,
						26.0,
						15.0,
						15.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "LOCK",
							"parameter_shortname": "LOCK",
							"parameter_type": 2,
							"parameter_mmax": 1.0,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_annotation_name": "Ignore PROB: everything fires"
						}
					}
				}
			},
			{
				"box": {
					"id": "PMODE",
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						"float"
					],
					"parameter_enable": 1,
					"varname": "PMODE",
					"patching_rect": [
						1140.0,
						440.0,
						60.0,
						15.0
					],
					"presentation": 1,
					"presentation_rect": [
						6.0,
						66.0,
						60.0,
						15.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "PMODE",
							"parameter_shortname": "PMODE",
							"parameter_type": 2,
							"parameter_enum": [
								"Repeats",
								"Burst",
								"Note"
							],
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_annotation_name": "What PROB decides: each repeat, the whole burst, or the whole note"
						}
					}
				}
			},
			{
				"box": {
					"id": "lbl-lock",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"text": "LOCK",
					"patching_rect": [
						1220.0,
						88.0,
						40.0,
						18.0
					],
					"presentation": 1,
					"presentation_rect": [
						302.0,
						8.0,
						40.0,
						18.0
					],
					"textjustification": 0
				}
			},
			{
				"box": {
					"id": "lbl-pmode",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"text": "PMODE",
					"patching_rect": [
						1220.0,
						130.0,
						40.0,
						18.0
					],
					"presentation": 1,
					"presentation_rect": [
						6.0,
						50.0,
						40.0,
						18.0
					],
					"textjustification": 0
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "i-lock",
					"maxclass": "newobj",
					"text": "i",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						1100.0,
						500.0,
						30.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "i-pmode",
					"maxclass": "newobj",
					"text": "i",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						1140.0,
						500.0,
						30.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "f-prob",
					"maxclass": "newobj",
					"text": "f",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1040.0,
						500.0,
						30.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "t-pass",
					"maxclass": "newobj",
					"text": "t l b",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"patching_rect": [
						160.0,
						268.0,
						45.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "rand-pass",
					"maxclass": "newobj",
					"text": "random 10000",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						260.0,
						268.0,
						80.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "expr-pass",
					"maxclass": "newobj",
					"text": "expr $i2 || ($i3 != 2) || ($i1 < $f4 * 100.)",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						260.0,
						292.0,
						290.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "gate-pass",
					"maxclass": "newobj",
					"text": "gate 1 1",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						160.0,
						292.0,
						66.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "t-plock",
					"maxclass": "newobj",
					"text": "t b b b",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"bang",
						"bang"
					],
					"patching_rect": [
						620.0,
						430.0,
						59.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "rand-burst",
					"maxclass": "newobj",
					"text": "random 10000",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						620.0,
						470.0,
						80.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "expr-burst",
					"maxclass": "newobj",
					"text": "expr $i1 < $f2 * 100.",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						620.0,
						500.0,
						140.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "t-fire",
					"maxclass": "newobj",
					"text": "t i b",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"int",
						"bang"
					],
					"patching_rect": [
						360.0,
						790.0,
						45.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "rand-hit",
					"maxclass": "newobj",
					"text": "random 10000",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						460.0,
						790.0,
						80.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "expr-fire",
					"maxclass": "newobj",
					"text": "expr ($i1 == 0) || $i2 || (($i3 == 0) && ($i4 < $f5 * 100.)) || (($i3 == 1) && $i6) || ($i3 == 2)",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						360.0,
						815.0,
						560.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "gate-fire",
					"maxclass": "newobj",
					"text": "gate 1 1",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						220.0,
						815.0,
						66.0,
						20.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "c-prob",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"linecount": 3,
					"text": "9. PROB (v3). Note mode: one roll per note before anything happens; a failed note is dropped (no cut). Burst mode: one roll at note-on decides all repeats. Repeats mode: a roll per repeat. The first hit always fires once the note is through; LOCK makes everything fire. Skipped hits are gaps (previous hit already got its note-off).",
					"patching_rect": [
						360.0,
						845.0,
						560.0,
						48.0
					]
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"source": [
						"midiin",
						0
					],
					"destination": [
						"parse",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"parse",
						1
					],
					"destination": [
						"format",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"parse",
						2
					],
					"destination": [
						"format",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"parse",
						3
					],
					"destination": [
						"format",
						3
					]
				}
			},
			{
				"patchline": {
					"source": [
						"parse",
						4
					],
					"destination": [
						"format",
						4
					]
				}
			},
			{
				"patchline": {
					"source": [
						"parse",
						5
					],
					"destination": [
						"format",
						5
					]
				}
			},
			{
				"patchline": {
					"source": [
						"parse",
						6
					],
					"destination": [
						"format",
						6
					]
				}
			},
			{
				"patchline": {
					"source": [
						"format",
						0
					],
					"destination": [
						"midiout",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"parse",
						0
					],
					"destination": [
						"t-in",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-in",
						1
					],
					"destination": [
						"unp-last",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"unp-last",
						0
					],
					"destination": [
						"i-last",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-in",
						0
					],
					"destination": [
						"gate-rtrg",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"gate-rtrg",
						0
					],
					"destination": [
						"format",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"RTRG",
						0
					],
					"destination": [
						"t-rtrg",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-rtrg",
						0
					],
					"destination": [
						"plus-rtrg",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"plus-rtrg",
						0
					],
					"destination": [
						"gate-rtrg",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-rtrg",
						1
					],
					"destination": [
						"i-last",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-last",
						0
					],
					"destination": [
						"sel-last",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"gate-rtrg",
						1
					],
					"destination": [
						"strip",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"strip",
						1
					],
					"destination": [
						"pack-in",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"strip",
						0
					],
					"destination": [
						"pack-in",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-note",
						1
					],
					"destination": [
						"unp-note",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"unp-note",
						0
					],
					"destination": [
						"i-pitch",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"unp-note",
						1
					],
					"destination": [
						"i-vel",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-note",
						2
					],
					"destination": [
						"t-kill",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-rtrg",
						2
					],
					"destination": [
						"t-kill",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-kill",
						1
					],
					"destination": [
						"m-stop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-note",
						0
					],
					"destination": [
						"t-start",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"RATE",
						0
					],
					"destination": [
						"i-rate",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"LEN",
						0
					],
					"destination": [
						"i-len",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-start",
						4
					],
					"destination": [
						"m-zero",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-start",
						3
					],
					"destination": [
						"i-rate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-rate",
						0
					],
					"destination": [
						"coll-rate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"coll-rate",
						0
					],
					"destination": [
						"t-rate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-rate",
						1
					],
					"destination": [
						"expr-n",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-start",
						2
					],
					"destination": [
						"i-len",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-len",
						0
					],
					"destination": [
						"coll-len",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"coll-len",
						0
					],
					"destination": [
						"expr-n",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-rate",
						0
					],
					"destination": [
						"gate-int",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"gate-int",
						0
					],
					"destination": [
						"translate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"translate",
						0
					],
					"destination": [
						"m-int-ms",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"gate-int",
						1
					],
					"destination": [
						"m-int-ticks",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-start",
						0
					],
					"destination": [
						"m-go",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-go",
						0
					],
					"destination": [
						"metro",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-stop",
						0
					],
					"destination": [
						"metro",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-int-ms",
						0
					],
					"destination": [
						"metro",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-int-ticks",
						0
					],
					"destination": [
						"metro",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"metro",
						0
					],
					"destination": [
						"t-hit",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-hit",
						0
					],
					"destination": [
						"i-idx",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-zero",
						0
					],
					"destination": [
						"i-idx",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-idx",
						0
					],
					"destination": [
						"t-idx",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-idx",
						3
					],
					"destination": [
						"plus-idx",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"plus-idx",
						0
					],
					"destination": [
						"i-idx",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-idx",
						0
					],
					"destination": [
						"expr-play",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-n",
						0
					],
					"destination": [
						"expr-play",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-play",
						0
					],
					"destination": [
						"sel-play",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel-play",
						0
					],
					"destination": [
						"m-stop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-play",
						0
					],
					"destination": [
						"i-pitch",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-pitch",
						0
					],
					"destination": [
						"t-pitch",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-pitch",
						0
					],
					"destination": [
						"pack-on",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pack-on",
						0
					],
					"destination": [
						"format",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-hit",
						1
					],
					"destination": [
						"i-sound",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-kill",
						0
					],
					"destination": [
						"i-sound",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-pitch",
						1
					],
					"destination": [
						"i-sound",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-sound",
						0
					],
					"destination": [
						"sel-sound",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel-sound",
						1
					],
					"destination": [
						"t-flush",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-flush",
						1
					],
					"destination": [
						"pack-off",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-flush",
						0
					],
					"destination": [
						"m-none",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-none",
						0
					],
					"destination": [
						"i-sound",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel-last",
						1
					],
					"destination": [
						"pack-off",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pack-off",
						0
					],
					"destination": [
						"format",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"thisdev",
						0
					],
					"destination": [
						"t-dev",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-dev",
						1
					],
					"destination": [
						"m-prop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-prop",
						0
					],
					"destination": [
						"observer",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-dev",
						0
					],
					"destination": [
						"m-path",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m-path",
						0
					],
					"destination": [
						"lpath",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lpath",
						0
					],
					"destination": [
						"observer",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"observer",
						0
					],
					"destination": [
						"t-play-state",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-play-state",
						1
					],
					"destination": [
						"plus-state",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"plus-state",
						0
					],
					"destination": [
						"gate-int",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-play-state",
						0
					],
					"destination": [
						"sel-stop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel-stop",
						0
					],
					"destination": [
						"t-kill",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"dbg-toggle",
						0
					],
					"destination": [
						"dbg-gate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pack-on",
						0
					],
					"destination": [
						"pre-note",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pack-off",
						0
					],
					"destination": [
						"pre-note",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-n",
						0
					],
					"destination": [
						"pre-burst",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre-note",
						0
					],
					"destination": [
						"dbg-gate",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre-burst",
						0
					],
					"destination": [
						"dbg-gate",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"dbg-gate",
						0
					],
					"destination": [
						"print",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"VFAD",
						0
					],
					"destination": [
						"f-vfad",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"CRV",
						0
					],
					"destination": [
						"f-crv",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-start",
						1
					],
					"destination": [
						"t-vsetup",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-vsetup",
						2
					],
					"destination": [
						"f-crv",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-vsetup",
						1
					],
					"destination": [
						"f-vfad",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"f-vfad",
						0
					],
					"destination": [
						"expr-ve",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"coll-len",
						0
					],
					"destination": [
						"expr-ve",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-vsetup",
						0
					],
					"destination": [
						"i-vel",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-vel",
						0
					],
					"destination": [
						"t-v0",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-v0",
						0
					],
					"destination": [
						"expr-ve",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-t",
						0
					],
					"destination": [
						"expr-vel",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-v0",
						1
					],
					"destination": [
						"expr-vel",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-ve",
						0
					],
					"destination": [
						"expr-vel",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"f-crv",
						0
					],
					"destination": [
						"expr-vel",
						3
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-vel",
						0
					],
					"destination": [
						"pack-on",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-idx",
						2
					],
					"destination": [
						"expr-t",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-n",
						0
					],
					"destination": [
						"expr-t",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"LOCK",
						0
					],
					"destination": [
						"i-lock",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"PMODE",
						0
					],
					"destination": [
						"i-pmode",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"PROB",
						0
					],
					"destination": [
						"f-prob",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pack-in",
						0
					],
					"destination": [
						"t-pass",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-pass",
						1
					],
					"destination": [
						"rand-pass",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rand-pass",
						0
					],
					"destination": [
						"expr-pass",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"LOCK",
						0
					],
					"destination": [
						"expr-pass",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"PMODE",
						0
					],
					"destination": [
						"expr-pass",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"PROB",
						0
					],
					"destination": [
						"expr-pass",
						3
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-pass",
						0
					],
					"destination": [
						"gate-pass",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-pass",
						0
					],
					"destination": [
						"gate-pass",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"gate-pass",
						0
					],
					"destination": [
						"t-note",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-vsetup",
						4
					],
					"destination": [
						"t-plock",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-plock",
						2
					],
					"destination": [
						"i-lock",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-plock",
						1
					],
					"destination": [
						"i-pmode",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-plock",
						0
					],
					"destination": [
						"f-prob",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"f-prob",
						0
					],
					"destination": [
						"expr-burst",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-vsetup",
						3
					],
					"destination": [
						"rand-burst",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rand-burst",
						0
					],
					"destination": [
						"expr-burst",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-idx",
						1
					],
					"destination": [
						"t-fire",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-fire",
						1
					],
					"destination": [
						"rand-hit",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rand-hit",
						0
					],
					"destination": [
						"expr-fire",
						3
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-fire",
						0
					],
					"destination": [
						"expr-fire",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-lock",
						0
					],
					"destination": [
						"expr-fire",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"i-pmode",
						0
					],
					"destination": [
						"expr-fire",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"f-prob",
						0
					],
					"destination": [
						"expr-fire",
						4
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-burst",
						0
					],
					"destination": [
						"expr-fire",
						5
					]
				}
			},
			{
				"patchline": {
					"source": [
						"expr-fire",
						0
					],
					"destination": [
						"gate-fire",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel-play",
						1
					],
					"destination": [
						"gate-fire",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"gate-fire",
						0
					],
					"destination": [
						"t-play",
						0
					]
				}
			}
		],
		"parameters": {
			"RTRG": [
				"RTRG",
				"RTRG",
				0
			],
			"RATE": [
				"RATE",
				"RATE",
				0
			],
			"LEN": [
				"LEN",
				"LEN",
				0
			],
			"parameterbanks": {
				"0": {
					"index": 0,
					"name": "Retrig",
					"parameters": [
						"RTRG",
						"RATE",
						"LEN",
						"VFAD",
						"CRV",
						"PROB",
						"LOCK",
						"-"
					]
				},
				"1": {
					"index": 1,
					"name": "Setup",
					"parameters": [
						"PMODE",
						"-",
						"-",
						"-",
						"-",
						"-",
						"-",
						"-"
					]
				}
			},
			"inherited_shortname": 1,
			"VFAD": [
				"VFAD",
				"VFAD",
				0
			],
			"CRV": [
				"CRV",
				"CRV",
				0
			],
			"PROB": [
				"PROB",
				"PROB",
				0
			],
			"LOCK": [
				"LOCK",
				"LOCK",
				0
			],
			"PMODE": [
				"PMODE",
				"PMODE",
				0
			]
		},
		"dependency_cache": [],
		"latency": 0,
		"is_mpe": 0,
		"project": {
			"version": 1,
			"creationdate": 3590052786,
			"modificationdate": 3590052786,
			"viewrect": [
				0.0,
				0.0,
				300.0,
				500.0
			],
			"autoorganize": 1,
			"hideprojectwindow": 1,
			"showdependencies": 1,
			"autolocalize": 0,
			"contents": {
				"patchers": {}
			},
			"layout": {},
			"searchpath": {},
			"detailsvisible": 0,
			"amxdtype": 1835887981,
			"readonly": 0,
			"devpathtype": 0,
			"devpath": ".",
			"sortmode": 0,
			"viewmode": 0
		},
		"autosave": 0
	}
}
