#!/bin/bash
# Script to apply full eBPF kernel configuration
# This script adds all necessary CONFIG options for complete eBPF support

set -e

CONFIG_FILE="$1"

if [ -z "$CONFIG_FILE" ]; then
    echo "Error: No config file specified"
    echo "Usage: $0 <path_to_gki_defconfig>"
    exit 1
fi

echo "Applying full eBPF configuration to $CONFIG_FILE"

# Function to add or update a config option
add_config() {
    local option="$1"
    local config_name="${option%=*}"

    # Check if the option already exists
    if grep -q "^${config_name}=" "$CONFIG_FILE"; then
        # Replace existing option
        sed -i "s/^${config_name}=.*/${option}/" "$CONFIG_FILE"
        echo "  Updated: $option"
    elif grep -q "^# ${config_name} is not set" "$CONFIG_FILE"; then
        # Replace disabled option
        sed -i "s/^# ${config_name} is not set/${option}/" "$CONFIG_FILE"
        echo "  Enabled: $option"
    else
        # Add new option
        echo "$option" >> "$CONFIG_FILE"
        echo "  Added: $option"
    fi
}

echo "========================================="
echo "Adding BASIC BPF SUPPORT (REQUIRED)"
echo "========================================="
add_config "CONFIG_BPF_SYSCALL=y"
add_config "CONFIG_BPF_JIT=y"
add_config "CONFIG_HAVE_BPF_JIT=y"
add_config "CONFIG_HAVE_EBPF_JIT=y"
add_config "CONFIG_HAVE_CBPF_JIT=y"
add_config "CONFIG_MODULES=y"
add_config "CONFIG_BPF=y"
add_config "CONFIG_BPF_EVENTS=y"
add_config "CONFIG_PERF_EVENTS=y"
add_config "CONFIG_HAVE_PERF_EVENTS=y"
add_config "CONFIG_PROFILING=y"

echo "========================================="
echo "Adding BTF (BPF Type Format) SUPPORT"
echo "========================================="
add_config "CONFIG_DEBUG_INFO_BTF=y"
add_config "CONFIG_PAHOLE_HAS_SPLIT_BTF=y"
add_config "CONFIG_DEBUG_INFO_BTF_MODULES=y"

echo "========================================="
echo "Adding SECURITY FEATURES"
echo "========================================="
add_config "CONFIG_BPF_JIT_ALWAYS_ON=y"
add_config "CONFIG_BPF_UNPRIV_DEFAULT_OFF=y"

echo "========================================="
echo "Adding CGROUP SUPPORT"
echo "========================================="
add_config "CONFIG_CGROUP_BPF=y"

echo "========================================="
echo "Adding NETWORK BPF FEATURES"
echo "========================================="
add_config "CONFIG_BPFILTER=y"
add_config "CONFIG_BPFILTER_UMH=y"
add_config "CONFIG_NET_CLS_BPF=y"
add_config "CONFIG_NET_ACT_BPF=y"
add_config "CONFIG_BPF_STREAM_PARSER=y"
add_config "CONFIG_LWTUNNEL_BPF=y"
add_config "CONFIG_NETFILTER_XT_MATCH_BPF=y"
add_config "CONFIG_IPV6_SEG6_BPF=y"

echo "========================================="
echo "Adding KPROBES SUPPORT (CRITICAL)"
echo "========================================="
add_config "CONFIG_KPROBE_EVENTS=y"
add_config "CONFIG_KPROBES=y"
add_config "CONFIG_HAVE_KPROBES=y"
add_config "CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y"
add_config "CONFIG_KPROBES_ON_FTRACE=y"

echo "========================================="
echo "Adding KPROBE ADVANCED FEATURES"
echo "========================================="
add_config "CONFIG_FPROBE=y"
add_config "CONFIG_BPF_KPROBE_OVERRIDE=y"

echo "========================================="
echo "Adding UPROBES SUPPORT (USER-SPACE)"
echo "========================================="
add_config "CONFIG_UPROBE_EVENTS=y"
add_config "CONFIG_ARCH_SUPPORTS_UPROBES=y"
add_config "CONFIG_UPROBES=y"
add_config "CONFIG_MMU=y"

echo "========================================="
echo "Adding TRACEPOINTS SUPPORT"
echo "========================================="
add_config "CONFIG_TRACEPOINTS=y"
add_config "CONFIG_HAVE_SYSCALL_TRACEPOINTS=y"

echo "========================================="
echo "Adding LSM (Linux Security Module) BPF"
echo "========================================="
add_config "CONFIG_BPF_LSM=y"

echo "========================================="
echo "Adding LIRC SUPPORT"
echo "========================================="
add_config "CONFIG_BPF_LIRC_MODE2=y"

echo "========================================="
echo "Adding ADDITIONAL ANDROID REQUIREMENTS"
echo "========================================="
# Debug information (required for BTF)
add_config "CONFIG_DEBUG_INFO=y"
add_config "CONFIG_DEBUG_INFO_DWARF4=y"
add_config "CONFIG_DEBUG_INFO_REDUCED=n"

# Function tracer (required for kprobes on ftrace)
add_config "CONFIG_FUNCTION_TRACER=y"
add_config "CONFIG_DYNAMIC_FTRACE=y"
add_config "CONFIG_FTRACE_SYSCALLS=y"

# Additional tracing infrastructure
add_config "CONFIG_TRACING=y"
add_config "CONFIG_GENERIC_TRACER=y"
add_config "CONFIG_FUNCTION_GRAPH_TRACER=y"
add_config "CONFIG_STACK_TRACER=y"
add_config "CONFIG_TRACER_MAX_TRACE=y"

# Kernel headers (CRITICAL for BCC on Android)
add_config "CONFIG_IKHEADERS=y"

# Additional performance monitoring
add_config "CONFIG_HW_PERF_EVENTS=y"
add_config "CONFIG_PERF_USE_VMALLOC=y"

# BPF sample programs
add_config "CONFIG_SAMPLES_BPF=y"

# Socket and networking
add_config "CONFIG_SOCK_CGROUP_DATA=y"
add_config "CONFIG_XDP_SOCKETS=y"
add_config "CONFIG_XDP_SOCKETS_DIAG=y"

# Additional security features
add_config "CONFIG_SECURITY_NETWORK=y"
add_config "CONFIG_SECURITY_PATH=y"

# Ensure kernel symbols are available
add_config "CONFIG_KALLSYMS=y"
add_config "CONFIG_KALLSYMS_ALL=y"

# Enable kernel probes for modules
add_config "CONFIG_MODULE_FORCE_LOAD=y"
add_config "CONFIG_MODULE_UNLOAD=y"
add_config "CONFIG_MODULE_FORCE_UNLOAD=y"

# Memory management for BPF
add_config "CONFIG_MEMCG=y"
add_config "CONFIG_MEMCG_KMEM=y"

# Additional debugging capabilities
add_config "CONFIG_DEBUG_FS=y"
add_config "CONFIG_DYNAMIC_DEBUG=y"

# Android specific
add_config "CONFIG_ANDROID_BINDER_IPC=y"
add_config "CONFIG_ANDROID_BINDERFS=y"
add_config "CONFIG_ANDROID_VENDOR_HOOKS=y"

# PSI for Android
add_config "CONFIG_PSI=y"

# Task accounting
add_config "CONFIG_TASKSTATS=y"
add_config "CONFIG_TASK_IO_ACCOUNTING=y"
add_config "CONFIG_TASK_DELAY_ACCT=y"

echo "========================================="
echo "eBPF configuration applied successfully!"
echo "========================================="