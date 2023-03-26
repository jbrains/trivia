#!/usr/bin/perl

package Game;

sub new {
    my ($class) = @_;
    my $self = bless( {}, $class );

    $self->{players}        = [];
    $self->{places}         = [ (0) x 6 ];
    $self->{purses}         = [ (0) x 6 ];
    $self->{in_penalty_box} = [ (0) x 6 ];

    $self->{pop_questions}     = [];
    $self->{science_questions} = [];
    $self->{sports_questions}  = [];
    $self->{rock_questions}    = [];

    $self->{current_player}                = 0;
    $self->{is_getting_out_of_penalty_box} = 0;

    for ( my $i = 0; $i < 50; $i++ ) {
        push( @{ $self->{pop_questions} },     "Pop Question $i" );
        push( @{ $self->{science_questions} }, "Science Question $i" );
        push( @{ $self->{sports_questions} },  "Sports Question $i" );
        push( @{ $self->{rock_questions} }, $self->create_rock_question($i) );
    }

    return $self;
}

sub create_rock_question {
    my ( $self, $index ) = @_;
    return "Rock Question $index";
}

sub is_playable {
    my ($self) = @_;
    return $self->how_many_players() >= 2;
}

sub add {
    my ( $self, $player_name ) = @_;
    push( @{ $self->{players} }, $player_name );
    ${ $self->{places} }[ $self->how_many_players() ]         = 0;
    ${ $self->{purses} }[ $self->how_many_players() ]         = 0;
    ${ $self->{in_penalty_box} }[ $self->how_many_players() ] = 0;

    print $player_name . " was added\n";
    print "They are player number " . scalar( @{ $self->{players} } ) . "\n";

    return 1;
}

sub how_many_players {
    my ($self) = @_;
    return scalar( @{ $self->{players} } );
}

sub roll {
    my ( $self, $roll ) = @_;
    print ${ $self->{players} }[ $self->{current_player} ]
        . " is the current player\n";
    print "They have rolled a " . $roll . "\n";

    if ( ${ $self->{in_penalty_box} }[ $self->{current_player} ] ) {
        if ( $roll % 2 != 0 ) {
            $self->{is_getting_out_of_penalty_box} = 1;

            print ${ $self->{players} }[ $self->{current_player} ]
                . " is getting out of the penalty box\n";
            ${ $self->{places} }[ $self->{current_player} ]
                = ${ $self->{places} }[ $self->{current_player} ] + $roll;
            if ( ${ $self->{places} }[ $self->{current_player} ] > 11 ) {
                ${ $self->{places} }[ $self->{current_player} ]
                    = ${ $self->{places} }[ $self->{current_player} ] - 12;
            }
            print ${ $self->{players} }[ $self->{current_player} ]
                . "'s new location is "
                . ${ $self->{places} }[ $self->{current_player} ] . "\n";
            print "The category is " . $self->_current_category() . "\n";
            $self->_ask_question();
        }
        else {
            print ${ $self->{players} }[ $self->{current_player} ]
                . " is not getting out of the penalty box\n";
            $self->{is_getting_out_of_penalty_box} = 0;
        }
    }
    else {
        ${ $self->{places} }[ $self->{current_player} ]
            = ${ $self->{places} }[ $self->{current_player} ] + $roll;
        if ( ${ $self->{places} }[ $self->{current_player} ] > 11 ) {
            ${ $self->{places} }[ $self->{current_player} ]
                = ${ $self->{places} }[ $self->{current_player} ] - 12;
        }

        print ${ $self->{players} }[ $self->{current_player} ]
            . "'s new location is "
            . ${ $self->{places} }[ $self->{current_player} ] . "\n";
        print "The category is " . $self->_current_category() . "\n";
        $self->_ask_question();
    }
}

sub _ask_question {
    my ($self) = @_;
    if ( $self->_current_category() eq 'Pop' ) {
        print pop( @{ $self->{pop_questions} } ) . "\n";
    }
    if ( $self->_current_category() eq 'Science' ) {
        print pop( @{ $self->{science_questions} } ) . "\n";
    }
    if ( $self->_current_category() eq 'Sports' ) {
        print pop( @{ $self->{sports_questions} } ) . "\n";
    }
    if ( $self->_current_category() eq 'Rock' ) {
        print pop( @{ $self->{rock_questions} } ) . "\n";
    }
}

sub _current_category {
    my ($self) = @_;
    return 'Pop' if ( ${ $self->{places} }[ $self->{current_player} ] == 0 );
    return 'Pop' if ( ${ $self->{places} }[ $self->{current_player} ] == 4 );
    return 'Pop' if ( ${ $self->{places} }[ $self->{current_player} ] == 8 );
    return 'Science'
        if ( ${ $self->{places} }[ $self->{current_player} ] == 1 );
    return 'Science'
        if ( ${ $self->{places} }[ $self->{current_player} ] == 5 );
    return 'Science'
        if ( ${ $self->{places} }[ $self->{current_player} ] == 9 );
    return 'Sports'
        if ( ${ $self->{places} }[ $self->{current_player} ] == 2 );
    return 'Sports'
        if ( ${ $self->{places} }[ $self->{current_player} ] == 6 );
    return 'Sports'
        if ( ${ $self->{places} }[ $self->{current_player} ] == 10 );
    return 'Rock';
}

sub was_correctly_answered {
    my ($self) = @_;
    if ( ${ $self->{in_penalty_box} }[ $self->{current_player} ] ) {
        if ( $self->{is_getting_out_of_penalty_box} ) {
            print "Answer was correct!!!!\n";
            ${ $self->{purses} }[ $self->{current_player} ] += 1;
            print ${ $self->{players} }[ $self->{current_player} ]
                . " now has "
                . ${ $self->{purses} }[ $self->{current_player} ]
                . " Gold Coins.\n";

            my $winner = $self->_did_player_win();
            $self->{current_player} += 1;
            if ( $self->{current_player} == scalar( @{ $self->{players} } ) )
            {
                $self->{current_player} = 0;
            }

            return $winner;
        }
        else {
            $self->{current_player} += 1;
            if ( $self->{current_player} == scalar( @{ $self->{players} } ) )
            {
                $self->{current_player} = 0;
            }
            return 1;
        }
    }
    else {
        print "Answer was corrent!!!!\n";
        ${ $self->{purses} }[ $self->{current_player} ] += 1;
        print ${ $self->{players} }[ $self->{current_player} ]
            . " now has "
            . ${ $self->{purses} }[ $self->{current_player} ]
            . " Gold Coins.\n";

        my $winner = $self->_did_player_win();
        $self->{current_player} += 1;
        if ( $self->{current_player} == scalar( @{ $self->{players} } ) ) {
            $self->{current_player} = 0;
        }

        return $winner;
    }
}

sub wrong_answer {
    my ($self) = @_;
    print "Question was incorrectly answered\n";
    print ${ $self->{players} }[ $self->{current_player} ]
        . " was sent to the penalty box\n";
    ${ $self->{in_penalty_box} }[ $self->{current_player} ] = 1;

    $self->{current_player} += 1;
    if ( $self->{current_player} == scalar( @{ $self->{players} } ) ) {
        $self->{current_player} = 0;
    }
    return 1;
}

sub _did_player_win {
    my ($self) = @_;
    return not( ${ $self->{purses} }[ $self->{current_player} ] == 6 );
}

package GameRunner;

my $not_a_winner = 0;

my $game = Game->new();

$game->add('Chet');
$game->add('Pat');
$game->add('Sue');

while (1) {
    $game->roll( int( rand(5) ) + 1 );

    if ( int( rand(9) ) == 7 ) {
        $not_a_winner = $game->wrong_answer();
    }
    else {
        $not_a_winner = $game->was_correctly_answered();
    }

    if ( not $not_a_winner ) {
        last;
    }
}
