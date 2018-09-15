#!/sbin/busybox sh

cat << CTAG
{
    name:I/O,
    elements:[
	{ SPane:{
                title:"IO status"
        }},
	{ SLiveLabel:{
		title:"MMC IO Read Ahead Size:",
		refresh:10000,
		action:"live IOReadAheadSize"
	}},
	{ SLiveLabel:{
		title:"MMC Current IO Scheduler:",
		refresh:10000,
		action:"live IOScheduler"
	}},
        { SPane:{
		title:"I/O schedulers",
		description:"Set the active I/O elevator algorithm. The scheduler decides how to handle I/O requests and how to handle them."
        }},
	{ SOptionList:{
		title:"Internal storage scheduler",
		default:`echo $(/res/synapse/actions/bracket-option /sys/block/mmcblk0/queue/scheduler)`,
		action:"bracket-option /sys/block/mmcblk0/queue/scheduler",
		values:[
`
			for IOSCHED in \`cat /sys/block/mmcblk0/queue/scheduler | sed -e 's/\]//;s/\[//'\`; do
			  echo "\"$IOSCHED\","
			done
`
		]
	}},
	{ SOptionList:{
		title:"SD card scheduler",
		default:`echo $(/res/synapse/actions/bracket-option /sys/block/mmcblk1/queue/scheduler)`,
		action:"bracket-option /sys/block/mmcblk1/queue/scheduler",
		values:[
`
			for IOSCHED in \`cat /sys/block/mmcblk1/queue/scheduler | sed -e 's/\]//;s/\[//'\`; do
			  echo "\"$IOSCHED\","
			done
`
		]
	}},
	{ SSeekBar:{
		title:"Internal storage read-ahead",
		description:"The read-ahead value on the internal phone memory.",
		max:2048, min:128, unit:"kB", step:128,
		default:`cat /sys/block/mmcblk0/queue/read_ahead_kb`,
                action:"generic /sys/block/mmcblk0/queue/read_ahead_kb"
	}},
	{ SSeekBar:{
		title:"SD card read-ahead",
		description:"The read-ahead value on the external SD card.",
		max:2048, min:128, unit:"kB", step:128,
		default:`cat /sys/block/mmcblk1/queue/read_ahead_kb`,
                action:"generic /sys/block/mmcblk1/queue/read_ahead_kb"
	}},
			{ SPane:{
				title:"General I/O Tunables",
				description:"Set the internal storage general tunables"
			}},
				{ SCheckBox:{
					description:"Draw entropy from spinning (rotational) storage.",
					label:"Add Random",
					default:`cat /sys/block/mmcblk0/queue/add_random`,
					action:"generic /sys/block/mmcblk0/queue/add_random"
				}},
				{ SCheckBox:{
					description:"Maintain I/O statistics for this storage device. Disabling will break I/O monitoring apps.",
					label:"I/O Stats",
					default:`cat /sys/block/mmcblk0/queue/iostats`,
					action:"generic /sys/block/mmcblk0/queue/iostats"
				}},
				{ SCheckBox:{
					description:"Treat device as rotational storage.",
					label:"Rotational",
					default:`cat /sys/block/mmcblk0/queue/rotational`,
					action:"generic /sys/block/mmcblk0/queue/rotational"
				}},				
				{ SOptionList:{
					title:"No Merges",
					description:"Types of merges (prioritization) the scheduler queue for this storage device allows.",
					default:`cat /sys/block/mmcblk0/queue/nomerges`,
					action:"generic /sys/block/mmcblk0/queue/nomerges",
					values:{
						0:"All", 1:"Simple Only", 2:"None"
					}
				}},
				{ SOptionList:{
					title:"RQ Affinity",
					description:"Try to have scheduler requests complete on the CPU core they were made from. Higher is more aggressive. Some kernels only support 0-1.",
					default:`cat /sys/block/mmcblk0/queue/rq_affinity`,
					action:"generic /sys/block/mmcblk0/queue/rq_affinity",
					values:{
						0:"Disabled", 1:"Enabled", 2:"Aggressive"
					}
				}},
	{ SDescription:{
		description:" "
	}},
	{ SSeekBar:{
		title:"NR Requests",
		description:" Maximum number of read (or write) requests that can be queued to the scheduler in the block layer.",
		step:128,
		min:128,
		max:2048,
		default:`cat /sys/block/mmcblk0/queue/nr_requests`,
		action:"generic /sys/block/mmcblk0/queue/nr_requests",
	}},
	{ SSpacer:{
		height:1
	}},
	
    ]
}
CTAG
