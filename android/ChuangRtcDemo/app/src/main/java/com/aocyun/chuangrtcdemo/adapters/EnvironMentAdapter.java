package com.aocyun.chuangrtcdemo.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.beans.EnvironmentBean;

import java.util.List;


public class EnvironMentAdapter extends RecyclerView.Adapter<EnvironMentAdapter.MyViewHolder> {
    private Context mContext;
    private List<EnvironmentBean> environmentBeans;

    public EnvironMentAdapter(Context mContext) {
        this.mContext = mContext;
    }

    public void setData(List<EnvironmentBean> environmentBeans) {
        this.environmentBeans = environmentBeans;
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_resolution, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MyViewHolder holder, final int position) {

        holder.resolutionTv.setText(environmentBeans.get(position).content);
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onItemClickListener.onItemClick(position);
            }
        });

    }


    private View getLayout(int layoutId) {
        return LayoutInflater.from(mContext).inflate(layoutId, null);
    }


    @Override
    public int getItemCount() {

        return (environmentBeans.size() != 0 ? environmentBeans.size() : 0);
    }


    public class MyViewHolder extends RecyclerView.ViewHolder {
        private TextView resolutionTv;


        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            resolutionTv = itemView.findViewById(R.id.item_content);
        }
    }

    private OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public interface OnItemClickListener {
        void onItemClick(int position);
    }
}
