use strict;
use utf8;
use Test::More tests => 1;
use Test::Requires qw(HTML::FormFu CGI);
use Data::Localize;


my $cgi = CGI->new({
    submit => 'submit'
});

my $localize = Data::Localize->new();
$localize->add_localizer(
    class => "Namespace",
    namespace => "HTML::FormFu::I18N"
);

# XXX HTML::FormFu's Change log does not say so, but apparently
# it doesn't allow single values to language parameter as of 0.09
# (Note: the author of Data::Localize no longer use FormFu, so
# please send pullreqs, if there are problems)
my $formfu = HTML::FormFu->new({
    languages => ['ja'],
});
$formfu->add_default_localize_object($localize);

$formfu->populate({
    auto_fieldset => 1,
    indicator => 'submit',
    elements => [
        {
            type => "Text",
            name => "required_field",
            constraints => [
                'Required'
            ]
        },
        {
            type => "Submit",
            name => "submit",
            value => "submit",
        }
    ]
});
$formfu->process($cgi);
$formfu->submitted_and_valid;

my $output = $formfu->render;
like($output, qr/必須項目/, "error message is properly localized");
