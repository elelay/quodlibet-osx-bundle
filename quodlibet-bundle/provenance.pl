#!/usr/bin/perl

use strict;

my $gtk_inst="/Volumes/MAC2/QLGtkOSX/inst";
my $jhbuild="/Volumes/MAC2/QLGtkOSX/inst/_jhbuild";
my $manifests="$jhbuild/manifests";
my $packagedbfile="$jhbuild/packagedb.xml";

sub usage
{
	my ($exitcode,$msg) = @_;
	print "Usage: $0 </path/to/BundledApplication.app>\n";
	print $msg if $msg;
	exit $exitcode;
}

usage(-1) unless scalar(@ARGV) == 1;
usage(0) if $ARGV[0] =~ /--?h(elp)?/;


my $bundleResources="$ARGV[0]/Contents/Resources";

usage(-1,"$bundleResources is not a directory\n") unless -d $bundleResources;

my @generated = ('/etc/gtk-3.0/gdk-pixbuf.loaders',
	             '/etc/gtk-3.0/gtk.immodules',
	             '/etc/gtk-3.0/settings.ini',
	             '/etc/pango/pango.modules',
	             '/etc/pango/pangorc',
	             '/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache',
	             '/share/glib-2.0/schemas/gschemas.compiled',
	             '/share/icons/Adwaita/icon-theme.cache',
	             '/share/icons/hicolor/icon-theme.cache',);

my @files= `find "$bundleResources"`;

my %prov;

print STDERR "I: grabbing packages provenance...\n";
foreach my $file (@files) {
	chomp $file;
	next if -d $file;
	my $short = $file;
	$short =~ s/$bundleResources//;
	next if grep {$_ eq $short} @generated;
	my $inst = "$gtk_inst$short";
	my @pkgs = `grep -Rl "$inst" "$manifests"`;
	@pkgs = map { chomp; $_ =~ s,$manifests/,,; $_ } @pkgs;
	if(scalar(@pkgs) eq 0) {
		print STDERR "W: pkg not found for $short\n";
	} else {
		if(scalar(@pkgs) > 1) {
			print STDERR "W: multiple pkgs found for $short: " . join(', ',@pkgs) . "\n";
		}
		foreach my $pkg (@pkgs){
			push(@{$prov{$pkg}}, $short);
		}
	}
}
print STDERR "I: packages provenance done\n";

my %versions;

print STDERR "I: grabbing packages versions...\n";
open(my $PACKAGEDB, '<', "$packagedbfile") || die "Unable to read $packagedbfile: $!\n";

while(defined(my $entry = <$PACKAGEDB>)){
	if($entry =~ /.*package="(.+?)" version="(.+?)"/){
		$versions{$1} = $2;
	}
}
close($PACKAGEDB);
print STDERR "I: packages versions done...\n";

print STDERR "I: exporting...\n";
foreach my $pkg (sort(keys(%prov))){
	my $version = $versions{$pkg};
	print "$pkg $version\n";
	foreach my $file (@{$prov{$pkg}}){
		print "  $file\n";
	}
}
print STDERR "I: export done\n";
