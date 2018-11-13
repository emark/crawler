#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: parse.pl
#
#        USAGE: ./parse.pl  
#
#  DESCRIPTION: Parsing web-pages
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Maxim Sviridenko (https://github.com/emark/), sviridenko.maxim@gmail.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 31.10.2018 23:41:32
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use Mojo::UserAgent;
use Mojo::DOM;

use Data::Dumper;

my %title = (
	'zavtraki' => 'Завтраки',
	'pervie-bluda' => 'Первые блюда',
	'vtorie-bluda' => 'Вторые блюда',
	'salati' => 'Салаты',
	'garniry' => 'Гарниры',
	'vipechka' => 'Выпечка',
	'sousy' => 'Соусы',
	'napitki' => 'Напитки',
);

my @sources = ('zavtraki','pervie-bluda','vtorie-bluda','salati','garniry','vipechka','sousy','napitki');
my $w = <>;
chomp $w;

my $ua = Mojo::UserAgent->new;
my $i = 1; #Counting items

foreach my $source(@sources){
	my $dom = Mojo::DOM->new($ua->get('http://localhost/crw/'.$source)->result->body);

	print "$title{$source}\n";

	my @items = $dom->find('div[itemprop]')->map('text');
	my $f = 0; #Clear formatting flag


	foreach my $item (@items){
		pop @{$item};
		shift @{$item};
		foreach my $key (@{$item}){
			$key=~s/^\s+(\d+)\s+$/$1/;
			$key=~s/^\s+$//;

			if (length($key)){
				if($f==1){
					print "$key\n";
					$f=0;
					$i++;	
				}else{
					print "$w-$i;$key;";
					$f++;
				};
			
			};
		};
	};
};

print "Generated at ".localtime;
