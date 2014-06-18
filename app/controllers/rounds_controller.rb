class RoundsController < ApplicationController

   #later we need to make this accessible only to CA/DCAs
   before_action :authorized_for_round, only: [:edit, :update, :destroy]
   before_action :authorized_for_make_round, only: [:create]

   def create
      @round = Round.new(); #user_params comes from private foo
      @round.tournament_id = round_params["tournament_id"].to_i;
      @round.status = GlobalConstants::TOURNAMENT_STATUS[:future]; #it is always coming up at first
      @round.round_num = 0; #@round.tournament.rounds.count + 1;
      @round.motion = Motion.new(wording: round_params["motion_attributes"]["wording"],
                                 user_id: current_user.id);

      if @round.save #if save successful (doesn't return false/nil)
         redirect_to(tournament_path(@round.tournament) + '/control/rounds');
      else
         #redirect_to(signup_path, object: @user);
         @tournament = @round.tournament;
         render('tournaments/rounds'); #render the new.html.erb template
      end
   end
   
   def edit
     @round = Round.find(params[:id])    
   end
   
   def update
      @round = Round.find(params[:id]);
      
      #checking the institution exists and security
      redirect_to root_path unless !@round.nil?
      #should this be in all of them?
      
      
      if @round.motion.update_attributes(wording: round_params[:motion_attributes][:wording], user_id: current_user.id)
         #handle a successful update
         redirect_to(tournament_path(@round.tournament) + '/control/rounds');
      else
         render 'rounds/edit';
      end
   end

   def destroy
      @round = Round.find(params[:id]);
      t = @round.tournament;
      
      ### we hopefully, will not go down this path
      #we need to do a shift of numbers
      #t.rounds.each { |r|
      #   if r.round_num > @round.round_num #this needs to shift
      #      r.update_attribute(round_num: r.round_num - 1); #shift up ranking
      #   end
      #}

      ### Let us render the round_num column irrelevant...
      
      @round.destroy();
      redirect_to(tournament_path(t.id) + '/control/rounds');
   end
   
   private
      def round_params #permit only said inputs
         params.require(:round).permit(:id, :round_num, :tournament_id, :motion_attributes => [:wording]);
         #^ the lazy mans way
      end


      def authorized_for_round
         @t = Round.find(params[:id]).tournament;
         redirect_to tournament_path(@t) unless current_user.in_tab_room?(@t);
      end

      #checks that the user is authorized to view ctrlPanel or edit tournament (tabRoom power)
      def authorized_for_make_round
         id = params[:round][:tournament_id]
         if !id.is_a?(Fixnum)
            id = id.to_i;
         end
         @t = Tournament.find(id);
         redirect_to tournament_path(@t) unless current_user.in_tab_room?(@t);
      end
end