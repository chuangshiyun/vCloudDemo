package com.aocyun.chuangrtcdemo.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.beans.ResolutionBeans;

import java.util.List;


public class ResolutionAdapter extends RecyclerView.Adapter<ResolutionAdapter.MyViewHolder> {
    private Context mContext;
    private List<ResolutionBeans> resolutionBeans;

    public ResolutionAdapter(Context mContext) {
        this.mContext = mContext;
    }

    public void setData(List<ResolutionBeans> mClassData) {
        this.resolutionBeans = mClassData;
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_resolution, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MyViewHolder holder, final int position) {

        holder.resolutionTv.setText(resolutionBeans.get(position).getContent());
        holder.itemView.setOnClickListener(v -> onItemClickListener.onItemClick(position));

    }

    private View getLayout(int layoutId) {
        return LayoutInflater.from(mContext).inflate(layoutId, null);
    }

    @Override
    public int getItemCount() {

        return (resolutionBeans.size() != 0 ? resolutionBeans.size() : 0);
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
