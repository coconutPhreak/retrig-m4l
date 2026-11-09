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
			170.0,
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
		"devicewidth": 170.0,
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
					"text": "RETRIG v1 - per-pad retrig (RTRG / RATE / LEN). All timing in the Max scheduler: no JS.",
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
					"text": "4. Start: reset hit index, look up RATE ticks (sets metro interval) and LEN ticks, N = ceil(LEN/RATE) (0 = INF), then start metro. Values are latched here.",
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
					"text": "7. Flush: note-off for the sounding pitch (-1 = nothing sounding).",
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
					"id": "moses-last",
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
						"",
						""
					],
					"text": "moses 0",
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
					"numoutlets": 4,
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
						"bang"
					],
					"text": "t b b b b",
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
								"0.25",
								"0.5",
								"0.75",
								"1",
								"1.5",
								"2",
								"3",
								"4",
								"6",
								"8",
								"12",
								"16",
								"24",
								"32",
								"48",
								"64",
								"96",
								"128",
								"INF"
							],
							"parameter_mmax": 19.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								8
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
						"count": 20,
						"data": [
							{
								"key": 0,
								"value": [
									15
								]
							},
							{
								"key": 1,
								"value": [
									30
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
									90
								]
							},
							{
								"key": 4,
								"value": [
									120
								]
							},
							{
								"key": 5,
								"value": [
									180
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
									360
								]
							},
							{
								"key": 8,
								"value": [
									480
								]
							},
							{
								"key": 9,
								"value": [
									720
								]
							},
							{
								"key": 10,
								"value": [
									960
								]
							},
							{
								"key": 11,
								"value": [
									1440
								]
							},
							{
								"key": 12,
								"value": [
									1920
								]
							},
							{
								"key": 13,
								"value": [
									2880
								]
							},
							{
								"key": 14,
								"value": [
									3840
								]
							},
							{
								"key": 15,
								"value": [
									5760
								]
							},
							{
								"key": 16,
								"value": [
									7680
								]
							},
							{
								"key": 17,
								"value": [
									11520
								]
							},
							{
								"key": 18,
								"value": [
									15360
								]
							},
							{
								"key": 19,
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
						170.0,
						20.0
					],
					"outlettype": [
						""
					],
					"text": "expr ($i1 + $i2 - 1) / $i2",
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
					"numoutlets": 2,
					"patching_rect": [
						20.0,
						775.0,
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
					"numoutlets": 2,
					"patching_rect": [
						220.0,
						825.0,
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
					"id": "moses-sound",
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
						"",
						""
					],
					"text": "moses 0",
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
						"moses-last",
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
						"pack-in",
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
						3
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
						2
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
						1
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
						1
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
						"sel-play",
						1
					],
					"destination": [
						"t-play",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"t-play",
						1
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
						"pack-on",
						1
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
						"moses-sound",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"moses-sound",
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
						"moses-last",
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
						"-",
						"-",
						"-",
						"-",
						"-"
					]
				}
			},
			"inherited_shortname": 1
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
