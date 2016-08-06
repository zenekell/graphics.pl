#!/usr/bin/perl

use warnings;
use strict;
use Scalar::Util qw(looks_like_number);

my ($what, $val, @any) = @ARGV;
my $version = "1.0.0";
sub usage { print "graphics.pl - v$version \n\nUsage: ./graphics.pl <get|fan|gpuClock|memClock|pcie> [<val>]\n"; exit 0; }
usage() if ( not defined $what );

my @cards = `ls -l /sys/class/drm/ | grep "card[0-5]\$" | awk -F'/' '{print \$NF}'`;
my $gpuCount = scalar @cards;

if ( $what =~ /^get$/i ) {
    my %gpu;
    for (my $i=0; $i < $gpuCount; $i++) {
        $gpu{$i}{'name'}     = `cat /sys/kernel/debug/dri/$i/name`;
        $gpu{$i}{'pm_info'}  = `cat /sys/kernel/debug/dri/$i/amdgpu_pm_info`;
        $gpu{$i}{'temp1'}    = `cat /sys/class/drm/card$i/device/hwmon/hwmon$i/temp1_input`;
        $gpu{$i}{'pwm1'}     = `cat /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1`;
        $gpu{$i}{'pwm1_max'} = `cat /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1_max`;
        $gpu{$i}{'pwm1_min'} = `cat /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1_min`;
        
    }
    print "gpu_count: $gpuCount\n";
    for my $i (keys %gpu) {
        $gpu{$i}{'temp1'} = $gpu{$i}{'temp1'} / 1000;
        chomp $gpu{$i}{'pwm1'};
        chomp $gpu{$i}{'pwm1_min'};
        chomp $gpu{$i}{'pwm1_max'};
        print "##############################################################\n".
              "name: $gpu{$i}{'name'}".
              "temp1: $gpu{$i}{'temp1'}\n".
              "pwm1: $gpu{$i}{'pwm1'} ($gpu{$i}{'pwm1_min'} - $gpu{$i}{'pwm1_max'})\n".
              "pm_info: $gpu{$i}{'pm_info'}";
    }
}
if ( $what =~ /^fan$/i ) {
    if ( not defined $val ) {
        for (my $i=0; $i < $gpuCount; $i++) {
            print "card".$i." pwm1: ".`cat /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1`;
        }
    } else {
        for (my $i=0; $i < $gpuCount; $i++) {
            my $pwm1_max = `cat /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1_max`;
            my $pwm1_min = `cat /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1_min`;
            chomp $pwm1_min;
            chomp $pwm1_max;
            if( looks_like_number($val) && $val >= $pwm1_min && $val <= $pwm1_max ) {
                system("echo 1 > /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1_enable"); # 0 for auto-fan
                system("echo $val > /sys/class/drm/card$i/device/hwmon/hwmon$i/pwm1");
            }
            else { print "card$i <val> = $val is out of range: $pwm1_min - $pwm1_max\n"; }
        }
    }
}
if ( $what =~ /^gpuClock$/i ) {
    if ( not defined $val ) {
        for (my $i=0; $i < $gpuCount; $i++) {
            my @clocks = `cat /sys/class/drm/card$i/device/pp_dpm_sclk`;
            my $clockCount = scalar @clocks;
            print "#### card".$i." has $clockCount possible settings: ####\n ";
            print "@clocks";
        }
    } else {
        for (my $i=0; $i < $gpuCount; $i++) {
            my @clocks = `cat /sys/class/drm/card$i/device/pp_dpm_sclk`;
            my $clockCount = scalar @clocks;
            if( looks_like_number($val) && $val >= 0 && $val < $clockCount ) {
                system("echo manual > /sys/class/drm/card$i/device/power_dpm_force_performance_level");
                system("echo $val > /sys/class/drm/card$i/device/pp_dpm_sclk");
                
                
            }
            else { print "card$i <val> = $val is out of range: 0 - ".($clockCount - 1)."\n"; }
        }
    }
}
if ( $what =~ /^memClock$/i ) {
    if ( not defined $val ) {
        for (my $i=0; $i < $gpuCount; $i++) {
            my @clocks = `cat /sys/class/drm/card$i/device/pp_dpm_mclk`;
            my $clockCount = scalar @clocks;
            print "#### card".$i." has $clockCount possible settings: ####\n ";
            print "@clocks";
        }
    } else {
        for (my $i=0; $i < $gpuCount; $i++) {
            my @clocks = `cat /sys/class/drm/card$i/device/pp_dpm_mclk`;
            my $clockCount = scalar @clocks;
            if( looks_like_number($val) && $val >= 0 && $val < $clockCount ) {
                system("echo manual > /sys/class/drm/card$i/device/power_dpm_force_performance_level");
                system("echo $val > /sys/class/drm/card$i/device/pp_dpm_mclk");
                
                
            }
            else { print "card$i <val> = $val is out of range: 0 - ".($clockCount - 1)."\n"; }
        }
    }
}
if ( $what =~ /^pcie$/i ) {
    if ( not defined $val ) {
        for (my $i=0; $i < $gpuCount; $i++) {
            my @clocks = `cat /sys/class/drm/card$i/device/pp_dpm_pcie`;
            my $clockCount = scalar @clocks;
            print "#### card".$i." has $clockCount possible settings: ####\n ";
            print "@clocks";
        }
    } else {
        for (my $i=0; $i < $gpuCount; $i++) {
            my @clocks = `cat /sys/class/drm/card$i/device/pp_dpm_pcie`;
            my $clockCount = scalar @clocks;
            if( looks_like_number($val) && $val >= 0 && $val < $clockCount ) {
                system("echo manual > /sys/class/drm/card$i/device/power_dpm_force_performance_level");
                system("echo $val > /sys/class/drm/card$i/device/pp_dpm_pcie");
                
                
            }
            else { print "card$i <val> = $val is out of range: 0 - ".($clockCount - 1)."\n"; }
        }
    }
}





0;
