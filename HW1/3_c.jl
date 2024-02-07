using LinearAlgebra
using Random

function create_rand_vector()
	seed = rand()
    if seed < .5
        state = zeros(Int, 5)
        state[1] = 1
        return state
    else
        state = zeros(Int, 5)
        state[4] = 1
        return state
    end
end

function forward_prop(t_mat, state)
    row_state = t_mat'*state;
    cum_row_state = cumsum(row_state)

    seed = rand()
    next_state_idx = findfirst(x -> x >= seed, cum_row_state)
    
    next_state = zeros(Int, length(state))
    next_state[next_state_idx] = 1

    return next_state
end

function state_history(t_mat, init, num_iter)
    history = [findfirst(x -> x == 1, init)]
    state = init
    for _ in 1:(num_iter-1)
        next_state = forward_prop(t_mat, state)
        state_idx = findfirst(x -> x == 1, next_state)
        push!(history, state_idx);
        state = next_state
    end

    history
end

function count_visits(history, len)
    visit_cnt = zeros(Int, len)

    for val in history
        visit_cnt[val] += 1
    end

    return visit_cnt
end

function do_trails(t_mat, num_trials, num_iter, len)
    cnt_tot = zeros(Int, 5)

    for _ in 1:num_trials
        init = [0,1,0,0,0]
        new_cnt = count_visits(state_history(t_mat, init, num_iter), len)
        cnt_tot = cnt_tot.+new_cnt
    end

    return cnt_tot./(num_trials)
end

M = [0.2 0.6 0 0.2 0; 0 0.3 0.7 0 0; 0 0.5 0.5 0 0; 0.1 0 0 0.1 0.8; 0 0 0 0 1]

trials = do_trails(M, 1_000_000, 10, 5)
println(sum(trials))
display(trials)
